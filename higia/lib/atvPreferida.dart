import 'package:flutter/material.dart';
import 'package:higia/atvDiaria.dart';
import 'package:higia/motivacao.dart';


class Atvpreferida extends StatefulWidget {
  const Atvpreferida({super.key});

  @override
  State<Atvpreferida> createState() => _AtvpreferidaState();
}

class _AtvpreferidaState extends State<Atvpreferida> {
  // Se por algum motivo estiveres a usar bool? noutros sítios, isto protege.
  bool? caminhadas;
  bool? corrida;
  bool? natacao;
  bool? passadeira;
  bool? outro;

  @override
  void initState() {
    super.initState();
    // Inicializa explicitamente (evita qualquer null)
    caminhadas = false;
    corrida = false;
    natacao = false;
    passadeira = false;
    outro = false;
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
                      value: caminhadas ?? false,
                      onChanged: (v) => setState(() => caminhadas = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Corrida'),
                      value: corrida ?? false,
                      onChanged: (v) => setState(() => corrida = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Natação'),
                      value: natacao ?? false,
                      onChanged: (v) => setState(() => natacao = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Passadeira'),
                      value: passadeira ?? false,
                      onChanged: (v) => setState(() => passadeira = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Outro'),
                      value: outro ?? false,
                      onChanged: (v) => setState(() => outro = v ?? false),
                    ),
                    SizedBox(height: 48),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const atvDiaria()),
                          );
                        },
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Motivacao()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue
                        ),
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
