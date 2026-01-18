import 'package:flutter/material.dart';
import 'package:higia/atvDiaria.dart';
import 'package:higia/motivacao.dart';
import 'package:higia/dadosRegisto.dart';

class Atvpreferida extends StatefulWidget {
  final RegistrationData data;
  const Atvpreferida({super.key, required this.data});

  @override
  State<Atvpreferida> createState() => _AtvpreferidaState();
}

class _AtvpreferidaState extends State<Atvpreferida> {
  // Se por algum motivo estiveres a usar bool? noutros sítios, isto protege.
  late bool caminhadas;
  late bool corrida;
  late bool natacao;
  late bool passadeira;
  late bool outro;

  @override
  void initState() {
    super.initState();
    caminhadas = widget.data.caminhadas;
    corrida = widget.data.corrida;
    natacao = widget.data.natacao;
    passadeira = widget.data.passadeira;
    outro = widget.data.atvOutro;
  }

  void _seguinte() {
    widget.data.caminhadas = caminhadas;
    widget.data.corrida = corrida;
    widget.data.natacao = natacao;
    widget.data.passadeira = passadeira;
    widget.data.atvOutro = outro;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Motivacao(data: widget.data)),
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
                  Image.asset(
                    'images/logo2.png',
                    height: 60,
                    width: 120,
                  ),
                  SizedBox(height: 32),
                  const Text(
                      'Indique a(s) sua(s) atividade preferida(s)',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 32),

                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Caminhadas'),
                      value: caminhadas,
                      onChanged: (v) => setState(() => caminhadas = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Corrida'),
                      value: corrida,
                      onChanged: (v) => setState(() => corrida = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Natação'),
                      value: natacao,
                      onChanged: (v) => setState(() => natacao = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Passadeira'),
                      value: passadeira,
                      onChanged: (v) => setState(() => passadeira = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Outro'),
                      value: outro,
                      onChanged: (v) => setState(() => outro = v ?? false),
                    ),
                    SizedBox(height: 48),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Anterior'),
                    ),
                    ElevatedButton(
                      onPressed: _seguinte,
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
