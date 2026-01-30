import 'package:flutter/material.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/menu.dart';
import 'package:higia/services/user_service.dart';

class Saude extends StatefulWidget {
  final int idutilizador;
  final RegistrationData data;

  const Saude({super.key, required this.data, required this.idutilizador});

  @override
  State<Saude> createState() => _SaudeState();
}

class SaudeStateModel {
  RegistrationData? data;
  bool loading;
  String? error;

  SaudeStateModel({this.data, this.loading = true, this.error});
}

class SaudeLogic {
  final UserService service;

  SaudeLogic(this.service);

  Future<RegistrationData?> carregarDados(int idutilizador) {
    return service.fetchUserData(idutilizador);
  }

  int calcularIdade(DateTime? nascimento) {
    if (nascimento == null) return 0;

    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;

    final aindaNaoFezAnos =
        (hoje.month < nascimento.month) ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day);

    if (aindaNaoFezAnos) idade--;

    return idade < 0 ? 0 : idade;
  }

  String formatarNumero(dynamic v, {String sufixo = ""}) {
    if (v == null) return "-";
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == "null") return "-";
    return "$s$sufixo";
  }

  String formatarTexto(dynamic v) {
    if (v == null) return "-";
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == "null") return "-";
    return s;
  }

  String gerarDica(String nivel) {
    final n = nivel.toLowerCase();
    final sedentario =
        (nivel == "-") || (n == "sedentário") || (n == "sedentario");

    if (sedentario) {
      return "Se passas muito tempo sentado, experimenta caminhar 10–15 min por dia.";
    }
    return "Boa! Mantém uma rotina consistente e tenta alongar 2–3 min após a atividade.";
  }
}

class _SaudeState extends State<Saude> {
  late final SaudeLogic logic;
  final SaudeStateModel state = SaudeStateModel();

  static const _cardColor = Color(0xFFE3F2FD);
  static const _textDark = Color(0xFF0D47A1);
  static const _iconBlue = Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();
    logic = SaudeLogic(UserService());
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      state.loading = true;
      state.error = null;
    });

    try {
      final fetched = await logic.carregarDados(widget.idutilizador);
      if (!mounted) return;

      setState(() {
        state.data = fetched ?? widget.data;
        state.loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        state.error = "Não foi possível carregar os dados.\nTenta novamente.";
        state.loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effective = state.data ?? widget.data;

    final idade = logic.calcularIdade(effective.dataNascimento);
    final peso = logic.formatarNumero(effective.peso, sufixo: " kg");
    final altura = logic.formatarNumero(effective.altura, sufixo: " cm");
    final nivel = logic.formatarTexto(effective.nivelAtividadeDiaria);
    final preferida = logic.formatarTexto(effective.AtividadePreferida);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Menu(idutilizador: widget.idutilizador),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            tooltip: "Atualizar",
            onPressed: _carregar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Center(child: Image.asset('images/Saude.png', height: 70)),
                    const SizedBox(height: 18),

                    if (state.loading) const _LoadingCard(),
                    if (!state.loading && state.error != null)
                      _ErrorCard(mensagem: state.error!, onRetry: _carregar),

                    if (!state.loading && state.error == null) ...[
                      _SectionCard(
                        title: "Resumo",
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.cake_outlined,
                              label: "Idade",
                              value: idade == 0 ? "-" : "$idade anos",
                            ),
                            _InfoRow(
                              icon: Icons.monitor_weight_outlined,
                              label: "Peso",
                              value: peso,
                            ),
                            _InfoRow(
                              icon: Icons.height,
                              label: "Altura",
                              value: altura,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      _SectionCard(
                        title: "Atividade",
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.directions_walk,
                              label: "Nível de atividade diária",
                              value: nivel,
                            ),
                            _InfoRow(
                              icon: Icons.favorite_outline,
                              label: "Atividade preferida",
                              value: preferida,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      _SectionCard(
                        title: "Dica",
                        child: Text(
                          logic.gerarDica(nivel),
                          style: const TextStyle(
                            fontSize: 16,
                            color: _textDark,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  static const _cardColor = Color(0xFFE3F2FD);
  static const _textDark = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const _textDark = Color(0xFF0D47A1);
  static const _iconBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _iconBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16, color: _textDark)),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  static const _cardColor = Color(0xFFE3F2FD);
  static const _textDark = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 14),
            Text("A carregar dados...", style: TextStyle(color: _textDark)),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String mensagem;
  final VoidCallback onRetry;

  const _ErrorCard({required this.mensagem, required this.onRetry});

  static const _cardColor = Color(0xFFE3F2FD);
  static const _textDark = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 36, color: _textDark),
            const SizedBox(height: 10),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textDark),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Tentar novamente"),
              style: ElevatedButton.styleFrom(foregroundColor: _textDark),
            ),
          ],
        ),
      ),
    );
  }
}
