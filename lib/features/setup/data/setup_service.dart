import '../../../core/supabase/supabase_client.dart';

class SetupService {
  Future<void> saveUserSetup({
    required String gender,
    required int age,
    required double weight,
    required double height,
    required String community,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No logged in user.');
    }

    await supabase.from('user_setup').upsert({
      'user_id': user.id,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'community': community,
    });
  }

  Future<Map<String, dynamic>?> getMySetup() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final data = await supabase
        .from('user_setup')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return data;
  }
}