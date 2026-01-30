import 'dart:async';
import 'package:flutter/material.dart';
import 'menu.dart';

class Sono extends StatefulWidget {
  final int idutilizador;

  const Sono({super.key, required this.idutilizador});

  @override
  State<Sono> createState() => _SonoState();
}

class _SonoState extends State<Sono> {
  // Opções de duração
  final List<int> opcoesHoras = [6, 7, 8, 9];
  int horasSelecionadas = 8;

  Duration get duracaoSono => Duration(hours: horasSelecionadas);

  Duration restante = const Duration(hours: 8);
  Timer? timer;
  bool aDormir = false;

  // Slider qualidade (1-5)
  double qualidadeSono = 3;

  // Registo de sono (offline, em memória)
  final List<String> registoSono = [];

  void iniciarSono() {
    _iniciarContagem(duracaoSono);
  }

  void iniciarSoneca() {
    _iniciarContagem(const Duration(minutes: 20));
  }

  void _iniciarContagem(Duration duracao) {
    timer?.cancel();

    setState(() {
      restante = duracao;
      aDormir = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (restante.inSeconds <= 0) {
        t.cancel();
        setState(() => aDormir = false);
        _sonoTerminado(duracao);
      } else {
        setState(() {
          restante -= const Duration(seconds: 1);
        });
      }
    });
  }

  void pararSono() {
    timer?.cancel();
    setState(() => aDormir = false);
  }

  void _sonoTerminado(Duration duracaoFinal) {
    final agora = TimeOfDay.now();
    final hh = agora.hour.toString().padLeft(2, '0');
    final mm = agora.minute.toString().padLeft(2, '0');

    final minutosTotais = duracaoFinal.inMinutes;
    final textoDuracao = minutosTotais >= 60
        ? "${duracaoFinal.inHours} h"
        : "${duracaoFinal.inMinutes} min";

    final qualidade = qualidadeSono.round();

    setState(() {
      registoSono.insert(
        0,
        "😴 $textoDuracao • Qualidade: $qualidade/5 • terminou às $hh:$mm",
      );
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bom descanso ✅'),
        content: Text(
          "Sessão concluída: $textoDuracao\nQualidade: $qualidade/5",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatar(Duration d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.inHours)}:${dois(d.inMinutes % 60)}:${dois(d.inSeconds % 60)}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acordar = DateTime.now().add(restante);

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
                    Center(child: Image.asset('images/sono.png', height: 80)),
                    const SizedBox(height: 18),

                    // Duração do sono
                    _CardSection(
                      title: "Duração do sono",
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bedtime_outlined,
                            color: Color(0xFF1565C0),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: horasSelecionadas,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.85),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: opcoesHoras
                                  .map(
                                    (h) => DropdownMenuItem(
                                      value: h,
                                      child: Text("$h horas"),
                                    ),
                                  )
                                  .toList(),
                              onChanged: aDormir
                                  ? null
                                  : (v) {
                                      if (v == null) return;
                                      setState(() {
                                        horasSelecionadas = v;
                                        restante = Duration(hours: v);
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Slider qualidade
                    _CardSection(
                      title: "Qualidade do sono (1–5)",
                      child: Column(
                        children: [
                          Text(
                            "Qualidade: ${qualidadeSono.round()}/5",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          Slider(
                            value: qualidadeSono,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: qualidadeSono.round().toString(),
                            onChanged: aDormir
                                ? null
                                : (v) => setState(() => qualidadeSono = v),
                          ),
                          const Text(
                            "Escolhe antes de iniciar (fica registado no fim).",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF0D47A1)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Temporizador
                    _CardSection(
                      title: "Temporizador",
                      child: Column(
                        children: [
                          Text(
                            formatar(restante),
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Acordar às ${acordar.hour.toString().padLeft(2, '0')}:${acordar.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 14),

                          if (!aDormir)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 10,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: iniciarSono,
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Iniciar Sono'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: iniciarSoneca,
                                  icon: const Icon(Icons.alarm),
                                  label: const Text('Soneca 20 min'),
                                ),
                              ],
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: pararSono,
                              icon: const Icon(Icons.stop),
                              label: const Text('Parar'),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Registo
                    _CardSection(
                      title: "Registo de sono",
                      child: registoSono.isEmpty
                          ? const Text(
                              "Ainda não terminaste nenhuma sessão.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: registoSono.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 10),
                              itemBuilder: (context, i) {
                                return ListTile(
                                  tileColor: Colors.white.withOpacity(0.75),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text(
                                    registoSono[i],
                                    style: const TextStyle(
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Color(0xFF1565C0),
                                    ),
                                    onPressed: () =>
                                        setState(() => registoSono.removeAt(i)),
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 14),

                    // Dicas
                    _CardSection(
                      title: "Dicas para dormir melhor",
                      child: const Column(
                        children: [
                          _TipLine(
                            text: "✅ Evita ecrãs 30–60 min antes de deitar",
                          ),
                          _TipLine(text: "✅ Quarto escuro e fresco ajuda"),
                          _TipLine(text: "✅ Cafeína: evita ao fim da tarde"),
                          _TipLine(text: "✅ Rotina: deita-te à mesma hora"),
                        ],
                      ),
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
      color: const Color(0xFFE3F2FD), // 🔵 azul claro do menu
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

class _TipLine extends StatelessWidget {
  final String text;
  const _TipLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Color(0xFF1565C0)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Color(0xFF0D47A1))),
          ),
        ],
      ),
    );
  }
}
