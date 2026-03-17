import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/supabase/supabase_client.dart';

class SessionService {
  static const _sessionIdKey = 'session_service.current_user_session_id';
  static const _sessionStartedAtKey =
      'session_service.current_user_session_started_at';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String> startSession() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user found for session start.');
    }

    await endSessionIfActive();

    final loginAt = DateTime.now().toUtc();
    final response = await supabase
        .from('user_sessions')
        .insert({
          'user_id': user.id,
          'login_at': loginAt.toIso8601String(),
          'created_at': loginAt.toIso8601String(),
        })
        .select('id')
        .single();

    final sessionId = response['id']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      throw StateError('User session was created without an id.');
    }

    final prefs = await _prefs;
    await prefs.setString(_sessionIdKey, sessionId);
    await prefs.setString(_sessionStartedAtKey, loginAt.toIso8601String());
    return sessionId;
  }

  Future<void> endSessionIfActive() async {
    final prefs = await _prefs;
    final sessionId = prefs.getString(_sessionIdKey);
    if (sessionId == null || sessionId.isEmpty) {
      return;
    }

    final logoutAt = DateTime.now().toUtc();
    final loginAt = DateTime.tryParse(
          prefs.getString(_sessionStartedAtKey) ?? '',
        ) ??
        logoutAt;

    await supabase.from('user_sessions').update({
      'logout_at': logoutAt.toIso8601String(),
      'session_duration_seconds': logoutAt.difference(loginAt).inSeconds,
    }).eq('id', sessionId);

    await clearLocalSession();
  }

  Future<void> clearLocalSession() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionIdKey);
    await prefs.remove(_sessionStartedAtKey);
  }
}