import 'package:supabase_flutter/supabase_flutter.dart';

class StepsRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> saveSteps(int idutilizador, DateTime when, int steps) async {
    try {
      final payload = <String, dynamic>{
        'idUtilizador': idutilizador,
        'created_at': when.toIso8601String().substring(0, 10), // store only date part
        'passos': steps,
      };

      await _client.from('Passos').insert(payload);
      return true;
    } catch (e, st) {
      // helpful debug log; do not expose in production logs
      print('StepsRepository.saveSteps error: $e\n$st');
      return false;
    }
  }

  /// Fetch recent passos records for a user. Returns a List of maps.
  Future<List<Map<String, dynamic>>> fetchSteps(int idutilizador, {int limit = 30}) async {
    try {

      final resRaw = await _client
          .from('Passos')
          .select('passos')
          .eq('idUtilizador', idutilizador)
          .order('created_at', ascending: false)
          .limit(limit) as List;
      return resRaw.map((e) => Map<String, dynamic>.from(e)).toList();
    }catch
    (e, st) {
      print('StepsRepository.fetchSteps error: $e\n$st');
      return [];
    }
  }
}
