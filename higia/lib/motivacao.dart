import 'package:flutter/material.dart';
import 'package:higia/objetivos.dart';
import 'package:higia/regEmail.dart';
import 'package:higia/dadosRegisto.dart';

class Motivacao extends StatefulWidget {
  final RegistrationData data;
  const Motivacao({super.key, required this.data, required this.idutilizador});
  final int idutilizador;

  @override
  State<Motivacao> createState() => _MotivacaoState();
}

class _MotivacaoState extends State<Motivacao> {
  String? motivacao;
late final int idutilizador;
  @override
  void initState() {
    super.initState();
    motivacao = widget.data.nivelMotivacao;
  }

  void _next() {
    widget.data.nivelMotivacao = motivacao;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Objetivos(data: widget.data)
      ));
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
                Image.asset('images/logo2.png', height: 60, width: 120),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Indique o seu nível de motivação?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 32),
                      RadioListTile<String>(
                        title: const Text('Muito baixa - Falta de vontade, adiamento constante'),
                        value: 'muitoBaixa',
                        groupValue: motivacao,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => motivacao = v),
                      ),
                      RadioListTile<String>(
                        title: const Text('Baixa - Alguma disposição ocasional'),
                        value: 'baixa',
                        groupValue: motivacao,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => motivacao = v),
                      ),
                      RadioListTile<String>(
                        title: const Text('Moderada - Consegue avançar'),
                        value: 'moderada',
                        groupValue: motivacao,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => motivacao = v),
                      ),
                      RadioListTile<String>(
                        title: const Text('Alta - Boa energia'),
                        value: 'alta',
                        groupValue: motivacao,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => motivacao = v),
                      ),
                      RadioListTile<String>(
                        title: const Text('Muito alta - Total empenho'),
                        value: 'muitoAlta',
                        groupValue: motivacao,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => motivacao = v),
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
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.blue),
                      child: const Text('Seguinte'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
