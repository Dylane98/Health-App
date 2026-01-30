import 'dart:async';
import 'package:flutter/material.dart';
import 'menu.dart';

class atividade extends StatefulWidget {
  final int idutilizador;
  const atividade({super.key, required this.idutilizador});

  @override
  State<atividade> createState() => _ActividadeState();
}

class _ActividadeState extends State<atividade> {
  // Passos (manual)
  int passos = 0;

  // Objetivo diário (passos)
  double objetivoPassos = 8000;

  // Timer de atividade
  Timer? timer;
  bool aTreinar = false;
  Duration restante = const Duration(minutes: 20);
  int minutosSelecionados = 20;

  // Tipo de atividade
  final List<String> tipos = [
    "Caminhada",
    "Corrida",
    "Bicicleta",
    "Alongamentos",
  ];
  String tipoSelecionado = "Caminhada";

  // Registo (offline)
  final List<String> registo = [];

  // Estimativa simples de calorias (muito aproximada)
  // (baseado em "calorias por minuto" médio por tipo)
  double get caloriasPorMinuto {
    switch (tipoSelecionado) {
      case "Corrida":
        return 10.0;
      case "Bicicleta":
        return 8.0;
      case "Alongamentos":
        return 3.0;
      default: // Caminhada
        return 5.0;
    }
  }

  double get caloriasEstimadas {
    final minutos = minutosSelecionados.toDouble();
    return minutos * caloriasPorMinuto;
  }

  void iniciarTreino() {
    timer?.cancel();
    setState(() {
      aTreinar = true;
      restante = Duration(minutes: minutosSelecionados);
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (restante.inSeconds <= 0) {
        t.cancel();
        setState(() => aTreinar = false);
        _treinoTerminado();
      } else {
        setState(() => restante -= const Duration(seconds: 1));
      }
    });
  }

  void pararTreino() {
    timer?.cancel();
    setState(() => aTreinar = false);
  }

  void _treinoTerminado() {
    final agora = TimeOfDay.now();
    final hh = agora.hour.toString().padLeft(2, '0');
    final mm = agora.minute.toString().padLeft(2, '0');

    final cal = caloriasEstimadas.round();

    setState(() {
      registo.insert(
        0,
        "🏃 $tipoSelecionado • ${minutosSelecionados} min • ~${cal} kcal • $hh:$mm",
      );
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Boa! ✅"),
        content: Text(
          "Treino concluído: $tipoSelecionado\nDuração: $minutosSelecionados min\n~$cal kcal",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String formatar(Duration d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return "${dois(d.inMinutes)}:${dois(d.inSeconds % 60)}";
  }

  double get progresso => (passos / objetivoPassos).clamp(0, 1);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faltam = (objetivoPassos - passos).clamp(0, 999999).round();

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
                    // troca o asset se tiveres outro ícone para atividade:
                    // exemplo: images/atividade.png
                    Center(child: Icon(Icons.directions_run, size: 70)),
                    const SizedBox(height: 12),

                    // Passos + progresso
                    _CardSection(
                      title: "Passos de hoje",
                      child: Column(
                        children: [
                          Text(
                            "$passos passos",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(value: progresso),
                          const SizedBox(height: 8),
                          Text(
                            "Objetivo: ${objetivoPassos.round()} • Faltam: $faltam",
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 10,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => setState(() => passos += 500),
                                icon: const Icon(Icons.add),
                                label: const Text("+500"),
                              ),
                              OutlinedButton.icon(
                                onPressed: passos == 0
                                    ? null
                                    : () => setState(
                                        () => passos = (passos - 500).clamp(
                                          0,
                                          999999,
                                        ),
                                      ),
                                icon: const Icon(Icons.remove),
                                label: const Text("-500"),
                              ),
                              TextButton.icon(
                                onPressed: () => setState(() => passos = 0),
                                icon: const Icon(Icons.refresh),
                                label: const Text("Reset"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Objetivo diário
                    _CardSection(
                      title: "Objetivo diário",
                      child: Column(
                        children: [
                          Text(
                            "Objetivo: ${objetivoPassos.round()} passos",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Slider(
                            value: objetivoPassos,
                            min: 2000,
                            max: 20000,
                            divisions: 18,
                            label: objetivoPassos.round().toString(),
                            onChanged: (v) =>
                                setState(() => objetivoPassos = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Treino guiado
                    _CardSection(
                      title: "Treino",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fitness_center),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: tipoSelecionado,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.85),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: tipos
                                      .map(
                                        (t) => DropdownMenuItem(
                                          value: t,
                                          child: Text(t),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: aTreinar
                                      ? null
                                      : (v) {
                                          if (v == null) return;
                                          setState(() => tipoSelecionado = v);
                                        },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              const Icon(Icons.timer_outlined),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: minutosSelecionados,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.85),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: const [10, 15, 20, 30, 45, 60]
                                      .map(
                                        (m) => DropdownMenuItem(
                                          value: m,
                                          child: Text("$m minutos"),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: aTreinar
                                      ? null
                                      : (v) {
                                          if (v == null) return;
                                          setState(() {
                                            minutosSelecionados = v;
                                            restante = Duration(minutes: v);
                                          });
                                        },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Center(
                            child: Text(
                              formatar(restante),
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Estimativa: ~${caloriasEstimadas.round()} kcal",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          if (!aTreinar)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: iniciarTreino,
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text("Iniciar"),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () => setState(
                                    () => restante = Duration(
                                      minutes: minutosSelecionados,
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Reset"),
                                ),
                              ],
                            )
                          else
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: pararTreino,
                                icon: const Icon(Icons.stop),
                                label: const Text("Parar"),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Registo
                    _CardSection(
                      title: "Registo de atividade",
                      child: registo.isEmpty
                          ? const Text(
                              "Ainda não registaste nenhuma atividade.",
                              textAlign: TextAlign.center,
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: registo.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 10),
                              itemBuilder: (context, i) {
                                return ListTile(
                                  tileColor: Colors.white.withOpacity(0.75),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  leading: const Icon(
                                    Icons.check_circle_outline,
                                  ),
                                  title: Text(registo[i]),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () =>
                                        setState(() => registo.removeAt(i)),
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 14),

                    // Dicas
                    _CardSection(
                      title: "Dicas rápidas",
                      child: const Column(
                        children: [
                          _TipLine(text: "✅ 10–20 min por dia já conta"),
                          _TipLine(
                            text: "✅ Alongar 2–3 min no fim ajuda muito",
                          ),
                          _TipLine(text: "✅ Água antes e depois do treino"),
                          _TipLine(
                            text: "✅ Caminhar após refeições ajuda a digestão",
                          ),
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
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
          const Icon(Icons.lightbulb_outline),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
