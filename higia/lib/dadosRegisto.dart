class RegistrationData {
  // 1º formulário
  String? nome;
  String? sobrenome;
  int? altura;
  int? peso;
  String? alergias;
  String? sexo; 

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
        // 'alergias': ..., // se adicionares depois
        if (idAtividade != null) 'idAtividade': idAtividade,
      };
}
