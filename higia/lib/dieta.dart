import 'package:flutter/material.dart';
import 'package:higia/objetivos.dart';
import 'package:higia/registry.dart';

class Dieta extends StatefulWidget {
  const Dieta({super.key});

  @override
  State<Dieta> createState() => _DietaState();
}

class _DietaState extends State<Dieta> {
  // Se por algum motivo estiveres a usar bool? noutros sítios, isto protege.
  bool? alimentacaoVariada;
  bool? vegetariano;
  bool? semLactose;
  bool? semGluten;
  bool? carne;
  bool? peixe;

  @override
  void initState() {
    super.initState();
    // Inicializa explicitamente (evita qualquer null)
    alimentacaoVariada = false;
    vegetariano = false;
    semLactose = false;
    semGluten = false;
    carne = false;
    peixe = false;
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
                      'Indique o seu tipo de dieta',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Alimentação variada'),
                      value: alimentacaoVariada ?? false,
                      onChanged: (v) => setState(() => alimentacaoVariada = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Vegetariano'),
                      value: vegetariano ?? false,
                      onChanged: (v) => setState(() => vegetariano = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sem lactose'),
                      value: semLactose ?? false,
                      onChanged: (v) => setState(() => semLactose = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sem glúten'),
                      value: semGluten ?? false,
                      onChanged: (v) => setState(() => semGluten = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Carne'),
                      value: carne ?? false,
                      onChanged: (v) => setState(() => carne = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Peixe'),
                      value: peixe ?? false,
                      onChanged: (v) => setState(() => peixe = v ?? false),
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
                            MaterialPageRoute(builder: (_) => const Registry()),
                          );
                        },
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Objetivos()),
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
