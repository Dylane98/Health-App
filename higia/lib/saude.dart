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

class _SaudeState extends State<Saude> {
  final UserService _userService = UserService();
  late Future<RegistrationData?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchRegistrationData();
  }

  Future<RegistrationData?> _fetchRegistrationData() =>
      _userService.fetchUserData(widget.idutilizador);

  void _recarregar() {
    setState(() {
      _future = _fetchRegistrationData();
    });
  }

  int _calcularIdade(DateTime? nascimento) {
    if (nascimento == null) return 0;
    final today = DateTime.now();
    int age = today.year - nascimento.year;
    if (today.month < nascimento.month ||
        (today.month == nascimento.month && today.day < nascimento.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  String _fmtNum(dynamic v, {String sufixo = ""}) {
    if (v == null) return "-";
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == "null") return "-";
    return "$s$sufixo";
  }

  String _fmtTexto(dynamic v) {
    if (v == null) return "-";
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == "null") return "-";
    return s;
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: _recarregar,
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

                    FutureBuilder<RegistrationData?>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const _LoadingCard();
                        }

                        if (snapshot.hasError) {
                          return _ErrorCard(
                            mensagem:
                                "Não foi possível carregar os dados da BD.\nTenta novamente.",
                            onRetry: _recarregar,
                          );
                        }

                        final fetched = snapshot.data;
                        final effective = fetched ?? widget.data;

                        final nascimento = effective.dataNascimento;
                        final idade = _calcularIdade(nascimento);

                        final peso = _fmtNum(effective.peso, sufixo: " kg");
                        final altura = _fmtNum(effective.altura, sufixo: " cm");
                        final nivel = _fmtTexto(effective.nivelAtividadeDiaria);
                        final preferida = _fmtTexto(
                          effective.AtividadePreferida,
                        );

                        return Column(
                          children: [
                            _CardSection(
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
                            _CardSection(
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
                            _CardSection(
                              title: "Dica",
                              child: Text(
                                (nivel == "-" ||
                                        nivel.toLowerCase() == "sedentário")
                                    ? "Se passas muito tempo sentado, experimenta caminhar 10–15 min por dia."
                                    : "Boa! Mantém uma rotina consistente e tenta alongar 2–3 min após a atividade.",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

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

// =================== CARD AZUL (IGUAL AO MENU) ===================

class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD), // 🔵 azul claro
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
                color: Color(0xFF0D47A1),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1565C0)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
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
            Text(
              "A carregar dados...",
              style: TextStyle(color: Color(0xFF0D47A1)),
            ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 36, color: Color(0xFF0D47A1)),
            const SizedBox(height: 10),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Tentar novamente"),
            ),
          ],
        ),
      ),
    );
  }
}
