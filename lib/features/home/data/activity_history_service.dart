import '../../../core/supabase/supabase_client.dart';
import '../models/activity_history.dart';

class ActivityHistoryService {
  static const int _defaultEntryCount = 7;
  static const double _kmPerStep = 0.00078;

  Future<ActivityHistoryData> loadHistory({
    int minimumEntries = _defaultEntryCount,
  }) async {
    final now = DateTime.now();
    final user = supabase.auth.currentUser;
    if (user == null) {
      return ActivityHistoryData(
        entries: _fallbackEntries(now: now, count: minimumEntries),
      );
    }

    final perDay = <String, _HistoryDayAggregate>{};

    try {
      final activityResponse = await supabase
          .from('user_activity_logs')
          .select('steps, earned_points, calories_burned, created_at')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      for (final row in (activityResponse as List).cast<Map<String, dynamic>>()) {
        final createdAt = DateTime.tryParse(row['created_at']?.toString() ?? '')?.toLocal();
        if (!_shouldIncludeInHistory(createdAt, now)) {
          continue;
        }

        final aggregate = perDay.putIfAbsent(_dayKey(createdAt!), () => _HistoryDayAggregate(date: createdAt));
        aggregate.points += _toInt(row['earned_points']);
        aggregate.steps += _toInt(row['steps']);
        aggregate.caloriesBurned += _toDouble(row['calories_burned']);
      }
    } catch (_) {
      return ActivityHistoryData(
        entries: _fallbackEntries(now: now, count: minimumEntries),
      );
    }

    try {
      final arResponse = await supabase
          .from('ar_sessions')
          .select('duration_seconds, started_at, created_at')
          .eq('user_id', user.id)
          .order('started_at', ascending: false);

      for (final row in (arResponse as List).cast<Map<String, dynamic>>()) {
        final startedAt = DateTime.tryParse(
              row['started_at']?.toString() ?? row['created_at']?.toString() ?? '',
            )
            ?.toLocal();
        if (!_shouldIncludeInHistory(startedAt, now)) {
          continue;
        }

        final aggregate = perDay.putIfAbsent(_dayKey(startedAt!), () => _HistoryDayAggregate(date: startedAt));
        aggregate.durationSeconds += _toInt(row['duration_seconds']);
      }
    } catch (_) {
      return ActivityHistoryData(
        entries: _fallbackEntries(now: now, count: minimumEntries),
      );
    }

    final entries = perDay.values
        .map(
          (aggregate) => ActivityHistoryEntry(
            date: aggregate.date,
            points: aggregate.points,
            distanceKm: aggregate.steps * _kmPerStep,
            caloriesBurned: aggregate.caloriesBurned,
            steps: aggregate.steps,
            durationSeconds: aggregate.durationSeconds,
            isFallback: false,
          ),
        )
        .where((entry) => !_isFutureDay(entry.date, now) && !_isSameDay(entry.date, now))
        .toList()
      ..sort((left, right) => right.date.compareTo(left.date));

    final filledEntries = _fillMissingPastDays(
      now: now,
      existingEntries: entries,
      minimumEntries: minimumEntries,
    );

    return ActivityHistoryData(entries: filledEntries);
  }

  List<ActivityHistoryEntry> _fillMissingPastDays({
    required DateTime now,
    required List<ActivityHistoryEntry> existingEntries,
    required int minimumEntries,
  }) {
    if (existingEntries.length >= minimumEntries) {
      return existingEntries;
    }

    final usedKeys = existingEntries.map((entry) => _dayKey(entry.date)).toSet();
    final filled = <ActivityHistoryEntry>[...existingEntries];
    var dayOffset = 1;
    while (filled.length < minimumEntries) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: dayOffset));
      final key = _dayKey(date);
      if (!usedKeys.contains(key)) {
        filled.add(_fallbackEntry(now: now, dayOffset: dayOffset));
        usedKeys.add(key);
      }
      dayOffset++;
    }

    filled.sort((left, right) => right.date.compareTo(left.date));
    return filled;
  }

  List<ActivityHistoryEntry> _fallbackEntries({
    required DateTime now,
    required int count,
  }) {
    return List<ActivityHistoryEntry>.generate(
      count,
      (index) => _fallbackEntry(now: now, dayOffset: index + 1),
      growable: false,
    );
  }

  ActivityHistoryEntry _fallbackEntry({
    required DateTime now,
    required int dayOffset,
  }) {
    final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: dayOffset));
    final points = 140 - (dayOffset * 7);
    final steps = 9800 - (dayOffset * 280);
    final calories = 520 - (dayOffset * 16);
    final durationMinutes = 62 - (dayOffset * 3);

    return ActivityHistoryEntry(
      date: date,
      points: points < 40 ? 40 : points,
      distanceKm: (steps < 4200 ? 4200 : steps) * _kmPerStep,
      caloriesBurned: calories < 180 ? 180 : calories.toDouble(),
      steps: steps < 4200 ? 4200 : steps,
      durationSeconds: (durationMinutes < 24 ? 24 : durationMinutes) * 60,
      isFallback: true,
    );
  }

  bool _shouldIncludeInHistory(DateTime? date, DateTime now) {
    if (date == null) {
      return false;
    }
    if (_isFutureDay(date, now)) {
      return false;
    }
    return !_isSameDay(date, now);
  }

  bool _isFutureDay(DateTime date, DateTime now) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedNow = DateTime(now.year, now.month, now.day);
    return normalizedDate.isAfter(normalizedNow);
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  String _dayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _HistoryDayAggregate {
  _HistoryDayAggregate({required this.date});

  final DateTime date;
  int points = 0;
  int steps = 0;
  double caloriesBurned = 0;
  int durationSeconds = 0;
}