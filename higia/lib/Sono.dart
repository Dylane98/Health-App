import 'dart:async';
import 'package:flutter/material.dart';
import 'menu.dart';

class Sono extends StatefulWidget {
  final int idutilizador;

  const Sono({super.key, required this.idutilizador});

  @override
  State<Sono> createState() => _SonoState();
}

class SonoModel {
  final List<int> opcoesHoras;
  int horasSelecionadas;

  Duration restante;
  bool aDormir;

  double qualidadeSono;
  final List<String> registoSono;

  SonoModel({
    this.opcoesHoras = const [6, 7, 8, 9],
    this.horasSelecionadas = 8,
    Duration? restante,
    this.aDormir = false,
    this.qualidadeSono = 3,
    List<String>? registoSono,
  }) : restante = restante ?? const Duration(hours: 8),
       registoSono = registoSono ?? [];

  Duration get duracaoSono => Duration(hours: horasSelecionadas);
}

class SonoController {
  Timer? _timer;

  void iniciarContagem({
    required Duration duracao,
    required VoidCallback onTick,
    required VoidCallback onTerminar,
    required bool Function() mountedCheck,
    required Duration Function() getRestante,
    required void Function(Duration novo) setRestante,
  }) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mountedCheck()) return;

      final r = getRestante();
      if (r.inSeconds <= 0) {
        t.cancel();
        onTerminar();
      } else {
        setRestante(r - const Duration(seconds: 1));
        onTick();
      }
    });
  }

  void parar() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }

  String formatar(Duration d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.inHours)}:${dois(d.inMinutes % 60)}:${dois(d.inSeconds % 60)}';
  }

  String textoDuracao(Duration duracao) {
    final minutosTotais = duracao.inMinutes;
    if (minutosTotais >= 60) return "${duracao.inHours} h";
    return "${duracao.inMinutes} min";
  }

  String horaAgora() {
    final agora = TimeOfDay.now();
    final hh = agora.hour.toString().padLeft(2, '0');
    final mm = agora.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
  }

  String horaAcordar(Duration restante) {
    final acordar = DateTime.now().add(restante);
    final hh = acordar.hour.toString().padLeft(2, '0');
    final mm = acordar.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
  }
}

class _SonoState extends State<Sono> {
  late final SonoModel model;
  late final SonoController controller;

  @override
  void initState() {
    super.initState();
    model = SonoModel();
    controller = SonoController();
  }

  void _iniciarSono() {
    _iniciarContagem(model.duracaoSono);
  }

  void _iniciarSoneca() {
    _iniciarContagem(const Duration(minutes: 20));
  }

  void _iniciarContagem(Duration duracao) {
    setState(() {
      model.restante = duracao;
      model.aDormir = true;
    });

    controller.iniciarContagem(
      duracao: duracao,
      mountedCheck: () => mounted,
      getRestante: () => model.restante,
      setRestante: (novo) => setState(() => model.restante = novo),
      onTick: () {},
      onTerminar: () {
        if (!mounted) return;
        setState(() => model.aDormir = false);
        _sonoTerminado(duracao);
      },
    );
  }

  void _pararSono() {
    controller.parar();
    setState(() => model.aDormir = false);
  }

  void _sonoTerminado(Duration duracaoFinal) {
    final textoDuracao = controller.textoDuracao(duracaoFinal);
    final qualidade = model.qualidadeSono.round();
    final hora = controller.horaAgora();

    setState(() {
      model.registoSono.insert(
        0,
        "😴 $textoDuracao • Qualidade: $qualidade/5 • terminou às $hora",
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horaAcordar = controller.horaAcordar(model.restante);

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
                              value: model.horasSelecionadas,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.85),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: model.opcoesHoras
                                  .map(
                                    (h) => DropdownMenuItem(
                                      value: h,
                                      child: Text("$h horas"),
                                    ),
                                  )
                                  .toList(),
                              onChanged: model.aDormir
                                  ? null
                                  : (v) {
                                      if (v == null) return;
                                      setState(() {
                                        model.horasSelecionadas = v;
                                        model.restante = Duration(hours: v);
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _CardSection(
                      title: "Qualidade do sono (1–5)",
                      child: Column(
                        children: [
                          Text(
                            "Qualidade: ${model.qualidadeSono.round()}/5",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          Slider(
                            value: model.qualidadeSono,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: model.qualidadeSono.round().toString(),
                            onChanged: model.aDormir
                                ? null
                                : (v) =>
                                      setState(() => model.qualidadeSono = v),
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

                    _CardSection(
                      title: "Temporizador",
                      child: Column(
                        children: [
                          Text(
                            controller.formatar(model.restante),
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Acordar às $horaAcordar',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (!model.aDormir)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 10,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _iniciarSono,
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Iniciar Sono'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0D47A1),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _iniciarSoneca,
                                  icon: const Icon(Icons.alarm),
                                  label: const Text('Soneca 20 min'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0D47A1),
                                  ),
                                ),
                              ],
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: _pararSono,
                              icon: const Icon(Icons.stop),
                              label: const Text('Parar'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D47A1),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _CardSection(
                      title: "Registo de sono",
                      child: model.registoSono.isEmpty
                          ? const Text(
                              "Ainda não terminaste nenhuma sessão.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: model.registoSono.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 10),
                              itemBuilder: (context, i) {
                                return ListTile(
                                  tileColor: Colors.white.withOpacity(0.75),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text(
                                    model.registoSono[i],
                                    style: const TextStyle(
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Color(0xFF1565C0),
                                    ),
                                    onPressed: () => setState(
                                      () => model.registoSono.removeAt(i),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 14),

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

class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
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
