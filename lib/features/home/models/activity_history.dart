class ActivityHistoryEntry {
  const ActivityHistoryEntry({
    required this.date,
    required this.points,
    required this.distanceKm,
    required this.caloriesBurned,
    required this.steps,
    required this.durationSeconds,
    required this.isFallback,
  });

  final DateTime date;
  final int points;
  final double distanceKm;
  final double caloriesBurned;
  final int steps;
  final int durationSeconds;
  final bool isFallback;

  String dateLabelRelativeTo(DateTime now) {
    final normalizedNow = DateTime(now.year, now.month, now.day);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final difference = normalizedNow.difference(normalizedDate).inDays;
    if (difference == 1) {
      return 'Yesterday';
    }
    return '${date.day} ${_monthLabels[date.month - 1]}';
  }

  String get distanceLabel => '${distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km';

  String get caloriesLabel => '${caloriesBurned.round()} kcal';

  String get stepsLabel => _formatWithGrouping(steps);

  String get pointsLabel => '${_formatWithGrouping(points)} pt';

  static String _formatWithGrouping(int value) {
    final raw = value.abs().toString();
    final buffer = StringBuffer();
    for (var index = 0; index < raw.length; index++) {
      final reverseIndex = raw.length - index;
      buffer.write(raw[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    final formatted = buffer.toString();
    return value < 0 ? '-$formatted' : formatted;
  }

  static const List<String> _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}

class ActivityHistoryData {
  const ActivityHistoryData({
    required this.entries,
  });

  final List<ActivityHistoryEntry> entries;

  ActivityHistoryEntry? get latestEntry => entries.isEmpty ? null : entries.first;
}