import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/supabase_service.dart' as sb;

/// UserService encapsulates user-related database operations and keeps
/// widget code free from direct DB calls (single responsibility).
class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  // local serializer to ensure DateTime values become ISO strings
  static dynamic _serializeForSupabase(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toIso8601String();
    if (value is Map) return value.map((k, v) => MapEntry(k.toString(), _serializeForSupabase(v)));
    if (value is List) return value.map((e) => _serializeForSupabase(e)).toList();
    return value;
  }

  /// Find or create an Atividade using helpers in supabase_service.dart
  Future<int?> fetchOrCreateAtividade(String? nivel, RegistrationData data) async {
    if (nivel == null || nivel.isEmpty) return null;
    try {
      final id = await sb.fetchOrCreateAtividade(nivel, data);
      if (id != null) data.idAtividade = id; // persist id into the model
      return id;
    } catch (e) {
      debugPrint('UserService.fetchOrCreateAtividade error: $e');
      return null;
    }
  }

  /// Create a user and related rows (objetivo_utilizador, motivacao_utilizador)
  /// Returns created idutilizador (int) or null on failure.
  Future<int?> createUser(RegistrationData data) async {
    try {
      // create or reuse Atividade
      final idAtividade = await fetchOrCreateAtividade(data.nivelAtividadeDiaria, data);
      if (idAtividade != null) data.idAtividade = idAtividade;

      final raw = data.utilizadorRow(idAtividade: idAtividade);
      // Make sure dates are serializable
      final serial = _serializeForSupabase(raw);
      final payload = serial is Map ? Map<String, dynamic>.from(serial) : <String, dynamic>{};

      final userRow = await _client.from('utilizador').insert(payload).select('idutilizador').single();
      final int idUtilizador = userRow['idutilizador'] as int;

      // objetivos
      final objetivos = data.objetivosIds();
      if (objetivos.isNotEmpty) {
        await _client.from('objetivo_utilizador').insert(objetivos.map((idObjetivo) => {
              'idutilizador': idUtilizador,
              'idobjetivo': idObjetivo,
              'Date': DateTime.now().toIso8601String(),
            }).toList());
      }

      // motivacao
      final idMotivacao = data.idMotivacao();
      if (idMotivacao != null) {
        await _client.from('motivacao_utilizador').insert({
          'idutilizador': idUtilizador,
          'idmotivacao': idMotivacao,
          'Date': DateTime.now().toIso8601String(),
        });
      }

      return idUtilizador;
    } catch (e, st) {
      debugPrint('createUser failed: $e\n$st');
      return null;
    }
  }

  /// Load user data, merging atividade row when present
  Future<RegistrationData?> fetchUserData(int idutilizador) async {
    try {
      final res = await _client.from('utilizador').select().eq('idutilizador', idutilizador).maybeSingle();
      if (res == null) return null;
      final Map<String, dynamic> row = Map<String, dynamic>.from(res as Map);
      final reg = RegistrationData.fromMap(row);

      // find idAtividade tolerant key
      dynamic idAtvVal = row['idAtividade'] ?? row['idatividade'] ?? row['id_atividade'];
      int? idAtividade;
      if (idAtvVal is int) idAtividade = idAtvVal;
      else if (idAtvVal is String) idAtividade = int.tryParse(idAtvVal);

      if (idAtividade != null) {
        final ares = await _client.from('Atividade').select().eq('idAtividade', idAtividade).maybeSingle();
        if (ares != null) {
          final Map<String, dynamic> arow = Map<String, dynamic>.from(ares as Map);
          final activityLevel = arow['AtividadeDiaria'] ?? arow['atividade_diaria'] ?? arow['nivel'] ?? arow['atividade'];
          final atividadePreferida = arow['AtividadePreferida'] ?? arow['atividade_preferida'];
          if (activityLevel != null) reg.nivelAtividadeDiaria = activityLevel.toString();
          if (atividadePreferida != null) reg.AtividadePreferida = atividadePreferida.toString();
          reg.idAtividade = idAtividade;
        }
      }

      return reg;
    } catch (e, st) {
      debugPrint('fetchUserData failed: $e\n$st');
      return null;
    }
  }
}
