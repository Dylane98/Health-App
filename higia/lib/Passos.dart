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
  State<Passos> createState() => _PassosState();
}

class _PassosState extends State<Passos> {
  final _service = getIt<StepCounterService>();
  StreamSubscription<int>? _stepsSub;

  int _passosHoje = 0;
  bool _running = false;
  bool _sensorActive = false;

  double _objetivoPassos = 8000;

  @override
  void initState() {
    super.initState();

    _stepsSub = _service.stepsStream.listen((s) {
      setState(() {
        _passosHoje = s;
        _sensorActive = true; // se há eventos, assume sensor
      });
    });

    _start();
  }

  double get _progresso => (_passosHoje / _objetivoPassos).clamp(0, 1);

  Future<void> _persistir() async {
    final repo = getIt<StepsRepository>();
    if (widget.idutilizador != 0) {
      await repo.saveSteps(widget.idutilizador, DateTime.now(), _passosHoje);
    }
  }

  Future<void> _start() async {
    await _service.start();
    setState(() => _running = true);
  }

  Future<void> _stop() async {
    await _service.stop();
    setState(() {
      _running = false;
      _sensorActive = false;
    });
    await _persistir();
  }

  Future<void> _reset() async {
    await _service.reset();
    setState(() => _passosHoje = 0);
  }

  @override
  void dispose() {
    _persistir();
    _stepsSub?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faltam = (_objetivoPassos - _passosHoje).clamp(0, 999999).round();

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

                    // -------- Passos hoje --------
                    _CardSection(
                      title: "Passos hoje",
                      child: Column(
                        children: [
                          Text(
                            '$_passosHoje',
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
                                _sensorActive ? Icons.sensors : Icons.smart_toy,
                                color: const Color(0xFF1565C0),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fonte: ${_sensorActive ? 'Sensor' : 'Simulador'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          LinearProgressIndicator(
                            value: _progresso,
                            backgroundColor: Colors.white,
                            color: const Color(0xFF1565C0),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Objetivo: ${_objetivoPassos.round()} • Faltam: $faltam",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // -------- Objetivo diário --------
                    _CardSection(
                      title: "Objetivo diário",
                      child: Column(
                        children: [
                          Text(
                            "Objetivo: ${_objetivoPassos.round()} passos",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Slider(
                            value: _objetivoPassos,
                            min: 2000,
                            max: 20000,
                            divisions: 18,
                            label: _objetivoPassos.round().toString(),
                            onChanged: (v) =>
                                setState(() => _objetivoPassos = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // -------- Controlos --------
                    _CardSection(
                      title: "Controlos",
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _running ? null : _start,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Iniciar'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _running ? _stop : null,
                            icon: const Icon(Icons.stop),
                            label: const Text('Parar'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reiniciar'),
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

// ================= CARD AZUL (IGUAL AO MENU) =================

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
