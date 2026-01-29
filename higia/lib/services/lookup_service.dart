import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LookupService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetches values for the `sexo` enum via RPC.
  Future<List<String>> fetchSexos() async {
    try {
      final res = await _client.rpc('sexo');
      if (res is List) return res.map((e) => e.toString()).toList();
      return [];
    } catch (e) {
      print('LookupService.fetchSexos error: $e');
      return [];
    }
  }
}
