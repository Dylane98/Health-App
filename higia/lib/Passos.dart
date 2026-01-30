import 'dart:async';
import 'package:flutter/material.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/menu.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/step_counter_service.dart';
import 'package:higia/services/steps_repository.dart';
import 'package:higia/steps_history.dart';

class Passos extends StatefulWidget {
  final RegistrationData data;
  final int idutilizador;

  const Passos({super.key, required this.data, required this.idutilizador});

  @override
  State<Passos> createState() => _PassosPageState();
}

class PassosModel {
  int passosHoje;
  bool running;
  bool sensorActive;
  double objetivoPassos;

  PassosModel({
    this.passosHoje = 0,
    this.running = false,
    this.sensorActive = false,
    this.objetivoPassos = 8000,
  });

  double get progresso => (passosHoje / objetivoPassos).clamp(0, 1);

  int get faltam => (objetivoPassos - passosHoje).clamp(0, 999999).round();
}

class PassosController {
  final StepCounterService stepService;
  final StepsRepository stepsRepo;
  final int idutilizador;

  StreamSubscription<int>? _sub;

  PassosController({
    required this.stepService,
    required this.stepsRepo,
    required this.idutilizador,
  });

  void ouvirPassos({required void Function(int passos) onPassos}) {
    _sub = stepService.stepsStream.listen(onPassos);
  }

  Future<void> start() => stepService.start();

  Future<void> stop() => stepService.stop();

  Future<void> reset() => stepService.reset();

  Future<void> persistir(int passosHoje) async {
    if (idutilizador != 0) {
      await stepsRepo.saveSteps(idutilizador, DateTime.now(), passosHoje);
    }
  }

  Future<void> close(int passosHoje) async {
    await persistir(passosHoje);
    await _sub?.cancel();
    stepService.dispose();
  }
}

class _PassosPageState extends State<Passos> {
  late final PassosModel model;
  late final PassosController controller;

  @override
  void initState() {
    super.initState();

    model = PassosModel();

    controller = PassosController(
      stepService: getIt<StepCounterService>(),
      stepsRepo: getIt<StepsRepository>(),
      idutilizador: widget.idutilizador,
    );

    controller.ouvirPassos(
      onPassos: (s) {
        if (!mounted) return;
        setState(() {
          model.passosHoje = s;
          model.sensorActive = true;
        });
      },
    );

    _start();
  }

  Future<void> _start() async {
    await controller.start();
    if (!mounted) return;
    setState(() => model.running = true);
  }

  Future<void> _stop() async {
    await controller.stop();
    if (!mounted) return;

    setState(() {
      model.running = false;
      model.sensorActive = false;
    });

    await controller.persistir(model.passosHoje);
  }

  Future<void> _reset() async {
    await controller.reset();
    if (!mounted) return;
    setState(() => model.passosHoje = 0);
  }

  @override
  void dispose() {
    controller.close(model.passosHoje);
    super.dispose();
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
        title: const Text('Passos'),
        actions: [
          IconButton(
            tooltip: "Histórico",
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      StepsHistory(idutilizador: widget.idutilizador),
                ),
              );
            },
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

                    _CardSection(
                      title: "Passos hoje",
                      child: Column(
                        children: [
                          Text(
                            '${model.passosHoje}',
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                model.sensorActive
                                    ? Icons.sensors
                                    : Icons.smart_toy,
                                color: const Color(0xFF1565C0),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fonte: ${model.sensorActive ? 'Sensor' : 'Simulador'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          LinearProgressIndicator(
                            value: model.progresso,
                            backgroundColor: Colors.white,
                            color: const Color(0xFF1565C0),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Objetivo: ${model.objetivoPassos.round()} • Faltam: ${model.faltam}",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _CardSection(
                      title: "Objetivo diário",
                      child: Column(
                        children: [
                          Text(
                            "Objetivo: ${model.objetivoPassos.round()} passos",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Slider(
                            value: model.objetivoPassos,
                            min: 2000,
                            max: 20000,
                            divisions: 18,
                            label: model.objetivoPassos.round().toString(),
                            onChanged: (v) {
                              setState(() => model.objetivoPassos = v);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _CardSection(
                      title: "Controlos",
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            onPressed: model.running ? null : _start,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Iniciar'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D47A1),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: model.running ? _stop : null,
                            icon: const Icon(Icons.stop),
                            label: const Text('Parar'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D47A1),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reiniciar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D47A1),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StepsHistory(
                                    idutilizador: widget.idutilizador,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.history),
                            label: const Text('Histórico'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D47A1),
                            ),
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
