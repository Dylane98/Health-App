// ignore_for_file: deprecated_member_use
// dart
import 'package:flutter/material.dart';
import 'package:higia/atvPreferida.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/user_service.dart';

final userService = getIt<UserService>();

class atvDiaria extends StatefulWidget {
  final RegistrationData data;
  const atvDiaria({super.key, required this.data});

  @override
  State<atvDiaria> createState() => _atvDiariaState();
}

class _atvDiariaState extends State<atvDiaria> {
  String? nivel;

  @override
  void initState() {
    super.initState();
    nivel = widget.data.nivelAtividadeDiaria;
  }

  Future<bool> _saveAtividade() async {
    try {
      // update local model before persisting
      widget.data.nivelAtividadeDiaria = nivel;
      final id = await userService.fetchOrCreateAtividade(nivel, widget.data);
      if (id != null) widget.data.idAtividade = id;
      return true;
    } catch (e, st) {
      debugPrint('Failed to insert Atividade: $e\n$st');
      return false;
    }
  }

  void _saveAndNext() async {
    // update local model
    widget.data.nivelAtividadeDiaria = nivel;

    await _saveAtividade();

    // proceed to next screen regardless; change to only-on-success if preferred
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Atvpreferida(data: widget.data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Image.asset('images/logo2.png', height: 60, width: 120),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Indique o seu nível de atividade diária.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      DropdownButtonFormField<String>(
                        value: nivel,
                        decoration: const InputDecoration(
                          labelText: 'Nível de atividade diária',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'sedentario', child: Text('Sedentário - Menos de 5000 passos p/ dia')),
                          DropdownMenuItem(value: 'ativo', child: Text('Ativo - 8000 a 10000 passos p/ dia')),
                          DropdownMenuItem(value: 'ideal', child: Text('Ideal - 40 a 60 minutos de atividade física diária')),
                        ],
                        onChanged: (v) => setState(() => nivel = v),
                        validator: (v) => (v == null || v.isEmpty) ? 'Selecione um nível' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Anterior'),
                    ),
                    ElevatedButton(
                      onPressed: _saveAndNext,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text('Seguinte'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
