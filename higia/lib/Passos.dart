import 'dart:async';
import 'package:flutter/material.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/step_counter_service.dart';
import 'package:higia/steps_history.dart';

import 'package:higia/services/steps_repository.dart';

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
  StreamSubscription<String>? _errSub;

  int _passosHoje = 0;
  String? _error;
  bool _running = false;
  bool _sensorActive = false;

  @override
  void initState() {
    super.initState();
    _stepsSub = _service.stepsStream.listen((s) {
      setState(() => _passosHoje = s);
    });
    _errSub = _service.errorStream.listen((e) {
      setState(() {
        _error = e;
        _sensorActive = false;
      });
    });
    // start automatically
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _error = null;
    });
    await _service.start();
    setState(() {
      _running = true;
      // sensorActive will be set once events arrive; leave as-is
    });
  }

  Future<void> _stop() async {
    await _service.stop();
    setState(() {
      _running = false;
      _sensorActive = false;
    });
    // persist current steps
    final repo = getIt<StepsRepository>();
    if (widget.idutilizador != 0) {
      await repo.saveSteps(widget.idutilizador, DateTime.now(), _passosHoje);
    }
  }

  Future<void> _reset() async {
    await _service.reset();
    setState(() => _passosHoje = 0);
  }

  @override
  void dispose() {
    // persist on dispose as well
    final repo = getIt<StepsRepository>();
    if (widget.idutilizador != 0) {
      repo.saveSteps(widget.idutilizador, DateTime.now(), _passosHoje);
    }
    _stepsSub?.cancel();
    _errSub?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Passos hoje', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('$_passosHoje', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Fonte: ${_sensorActive ? 'Sensor' : 'Simulador'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _running ? null : _start, child: const Text('Iniciar')),
                ElevatedButton(onPressed: _running ? _stop : null, child: const Text('Parar')),
                ElevatedButton(onPressed: _reset, child: const Text('Reset')),
                ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => StepsHistory(idutilizador: widget.idutilizador)));
                }, child: const Text('History')),
              ],
            ),
            const SizedBox(height: 12),
            if (_error != null) ...[
              Text('Sensor error: $_error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _start, child: const Text('Retry sensor')),
            ],
            const SizedBox(height: 24),
            const Text('Nota: se o dispositivo não suportar pedómetro, o simulador será usado.'),
          ],
        ),
      ),
    );
  }
}