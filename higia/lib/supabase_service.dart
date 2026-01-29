import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:higia/dadosRegisto.dart';

// Reusable Supabase helpers for Atividade operations.

/// Recursively serialize DateTime objects (and nested structures) into
/// JSON-encodable values (ISO strings).
dynamic _serializeForSupabase(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toIso8601String();
  if (value is Map) return value.map((k, v) => MapEntry(k.toString(), _serializeForSupabase(v)));
  if (value is List) return value.map((e) => _serializeForSupabase(e)).toList();
  return value;
}

/// Try to find an Atividade row by the activity level (nivel). Returns the
/// id (int) if found, otherwise null.
Future<int?> fetchAtividadeIdByNivel(String nivel) async {
  final client = Supabase.instance.client;
  final res = await client.from('Atividade').select().eq('AtividadeDiaria', nivel).maybeSingle();
  if (res == null) return null;
  final Map<String, dynamic> row = Map<String, dynamic>.from(res as Map);
  final val = row['idAtividade'] ?? row['id'] ?? row['id_atividade'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val);
  return null;
}

/// Insert a new Atividade row from [payload] and return the inserted id (int)
/// or null on failure.
Future<int?> createAtividade(Map<String, dynamic> payload) async {
  final client = Supabase.instance.client;
  final serial = _serializeForSupabase(payload);
  final Map<String, dynamic> map = serial is Map ? Map<String, dynamic>.from(serial) : {};

  final inserted = await client.from('Atividade').insert(map).select('idAtividade').maybeSingle();
  if (inserted == null) return null;
  final Map<String, dynamic> irow = Map<String, dynamic>.from(inserted as Map);
  final val = irow['idAtividade'] ?? irow['id'] ?? irow['id_atividade'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val);
  return null;
}

/// Convenience: try to fetch an existing Atividade by nivel; if not found,
/// create one using information from [data] and return the id.
Future<int?> fetchOrCreateAtividade(String nivel, RegistrationData data) async {
  if (nivel.isEmpty) return null;
  try {
    final existingId = await fetchAtividadeIdByNivel(nivel);
    if (existingId != null) return existingId;

    final payload = {
      'AtividadeDiaria': nivel,
      'AtividadePreferida': data.atividadePreferidaResumo(),
    };
    return await createAtividade(payload);
  } catch (e) {
    // Bubble up null on failure; callers should handle/log errors as necessary.
    return null;
  }
}
