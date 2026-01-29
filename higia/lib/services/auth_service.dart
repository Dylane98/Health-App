import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Returns idutilizador if credentials are correct, otherwise null.
  Future<int?> signIn(String username, String password) async {
    try {
      final res = await _client.from('utilizador').select('idutilizador').eq('username', username).eq('password', password).limit(1);
      if (res.isEmpty) return null;
      final id = res.first['idutilizador'];
      if (id is int) return id;
      if (id is String) return int.tryParse(id);
      return null;
    } catch (e) {
      debugPrint('AuthService.signIn error: $e');
      return null;
    }
  }

  Future<bool> changePassword(int idutilizador, String current, String next) async {
    try {
      final res = await _client.from('utilizador').select('idutilizador').eq('idutilizador', idutilizador).eq('password', current).limit(1);
      if (res.isEmpty) return false;
      await _client.from('utilizador').update({'password': next}).eq('idutilizador', idutilizador);
      return true;
    } catch (e) {
      debugPrint('AuthService.changePassword error: $e');
      return false;
    }
  }
}
