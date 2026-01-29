class RegistrationData {
  int? idutilizador;
  int? idAtividade;

  // 1º formulário
  String? nome;
  String? sobrenome;
  int? altura;
  double? peso;
  String? alergias;
  String? sexo;
  DateTime? dataNascimento;

  // 2º formulário (Dieta) - checkboxes
  bool alimentacaoVariada = false;
  bool vegetariano = false;
  bool semLactose = false;
  bool semGluten = false;
  bool carne = false;
  bool peixe = false;

  // 3º formulário (Objetivos) - checkboxes
  bool melhorarAlimentacao = false;
  bool melhorarHumor = false;
  bool melhorarSono = false;
  bool atvFisica = false;
  bool redStress = false;
  bool ganharEnergia = false;
  bool outro = false;

  // 4º formulário (Objpeso) - radio
  String? objetivoPeso; // perderPeso/manterPeso/ganharPeso/semObjetivo

  // 5º formulário (AtvDiaria) - radio
  String? nivelAtividadeDiaria; // sedentario/ativo/ideal
  String? AtividadePreferida;

  // 6º formulário (AtvPreferida) - checkboxes
  bool caminhadas = false;
  bool corrida = false;
  bool natacao = false;
  bool passadeira = false;
  bool atvOutro = false;

  // 7º formulário (Motivacao) - radio
  String? nivelMotivacao; // muitoBaixa/baixa/moderada/alta/muitoAlta

  // Último (RegEmail)
  String? username;
  String? email;
  String? password;

  RegistrationData({
    this.nome,
    this.email,
    this.dataNascimento,
    this.sexo,
    this.peso,
    this.altura,
    this.nivelAtividadeDiaria,
    this.idutilizador,
    this.idAtividade,
  });
  // --- Helpers para a tua BD (várias tabelas) ---

  /// Texto para guardar em utilizador.dieta (varchar)
  String dietaResumo() {
    final parts = <String>[];
    if (alimentacaoVariada) parts.add('Alimentação variada');
    if (vegetariano) parts.add('Vegetariano');
    if (semLactose) parts.add('Sem lactose');
    if (semGluten) parts.add('Sem glúten');
    if (carne) parts.add('Carne');
    if (peixe) parts.add('Peixe');
    return parts.join('; ');
  }

  /// Texto opcional com atividades preferidas (se quiseres guardar como varchar)
  String atividadePreferidaResumo() {
    final parts = <String>[];
    if (caminhadas) parts.add('Caminhadas');
    if (corrida) parts.add('Corrida');
    if (natacao) parts.add('Natação');
    if (passadeira) parts.add('Passadeira');
    if (atvOutro) parts.add('Outro');
    return parts.join('; ');
  }

  /// IDs para a tabela objetivo_utilizador (assumindo IDs fixos na tabela objetivo)
  /// Ajusta os números se os teus idobjetivo forem diferentes.
  List<int> objetivosIds() {
    final ids = <int>[];
    if (melhorarAlimentacao) ids.add(1);
    if (melhorarHumor) ids.add(2);
    if (melhorarSono) ids.add(3);
    if (atvFisica) ids.add(4);
    if (redStress) ids.add(5);
    if (ganharEnergia) ids.add(6);
    if (outro) ids.add(7);

    // objetivo relacionado com o peso pode ser tratado como objetivo também (opcional)
    // Exemplo de mapeamento (ajusta IDs):
    // if (objetivoPeso == 'perderPeso') ids.add(8);
    // if (objetivoPeso == 'manterPeso') ids.add(9);
    // if (objetivoPeso == 'ganharPeso') ids.add(10);

    return ids;
  }

  /// idmotivacao para motivacao_utilizador (assumindo IDs fixos)
  /// Ajusta os números se os teus ids forem diferentes.
  int? idMotivacao() {
    switch (nivelMotivacao) {
      case 'muitoBaixa':
        return 1;
      case 'baixa':
        return 2;
      case 'moderada':
        return 3;
      case 'alta':
        return 4;
      case 'muitoAlta':
        return 5;
      default:
        return null;
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.tryParse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // Helper: parse dynamic to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '.'));
    return null;
  }

  /// Linha para inserir na tabela utilizador
  /// (não inclui idAtividade porque normalmente vais calcular/definir no fim)
  Map<String, dynamic> utilizadorRow({int? idAtividade}) => {
        'nome': nome,
        'sobrenome': sobrenome,
        'sexo': sexo, // se não tiveres, podes apagar esta linha
        'altura': altura,
        'peso': peso,
        'alergias': alergias,
        'dataregisto': DateTime.now().toIso8601String(),
        'email': email,
        'username': username,
        'password': password,
        'dieta': dietaResumo(),
        'datanascimento': dataNascimento,
        // 'alergias': ..., // se adicionares depois
        if (idAtividade != null) 'idAtividade': idAtividade,
      };

  factory RegistrationData.fromMap(Map<String, dynamic> map) {
    // tolerant lookup for activity level column
    final nivel = map['nivelAtividadeDiaria'] ??
        map['nivel_atividade_diaria'] ??
        map['nivelatividadediaria'] ??
        map['nivelatividade'] ??
        map['nivel_atividade'] ??
        map['nivel'];

    return RegistrationData(
      nome: map['nome']?.toString(),
      email: map['email']?.toString(),
      dataNascimento: _parseDate(map['datanascimento'] ?? map['data_nascimento'] ?? map['birthdate']),
      sexo: map['genero']?.toString(),
      peso: _parseDouble(map['peso']),
      altura: map['altura'],
      nivelAtividadeDiaria: nivel?.toString(),
      idutilizador: map['idutilizador'], // Adicionado para suportar idutilizador
      idAtividade: map['idAtividade'], // Adicionado para suportar idAtividade
    );
  }

  // Convert back to map (useful for updates)
  Map<String, dynamic> toMap() {
    return {
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (dataNascimento != null) 'datanascimento': dataNascimento!.toIso8601String(),
      if (sexo != null) 'genero': sexo,
      if (peso != null) 'peso': peso,
      if (altura != null) 'altura': altura,
      if (nivelAtividadeDiaria != null) 'nivelAtividadeDiaria': nivelAtividadeDiaria,
      if (idutilizador != null) 'idutilizador': idutilizador, // Adicionado para suportar idutilizador
      if (idAtividade != null) 'idAtividade': idAtividade, // Adicionado para suportar idAtividade
    };
  }

  RegistrationData copyWith({
    String? nome,
    String? email,
    DateTime? dataNascimento,
    String? sexo,
    double? peso,
    int? altura,
    int? idutilizador,
    int? idAtividade,
  })
  {
    return RegistrationData(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      sexo: sexo ?? this.sexo,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      nivelAtividadeDiaria: nivelAtividadeDiaria ?? this.nivelAtividadeDiaria,
      idutilizador: idutilizador ?? this.idutilizador, // Adicionado para suportar idutilizador
      idAtividade: idAtividade ?? this.idAtividade, // Adicionado para suportar idAtividade
    );
  }
}
