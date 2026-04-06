import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/profile_model.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

// Provider du profil global de l'utilisateur
final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  return ProfileNotifier(Supabase.instance.client);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final SupabaseClient _supabase;

  ProfileNotifier(this._supabase) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        state = AsyncValue.data(ProfileModel.fromJson(response));
      } else {
        state = const AsyncValue.data(null); // Pas encore de profil
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utilisateur non connecté");

      final data = profile.toJson();
      data['id'] = user.id;

      await _supabase.from('profiles').upsert(data);
      
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
