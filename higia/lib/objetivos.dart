import 'package:flutter/material.dart';
import 'package:higia/dieta.dart';
import 'package:higia/objPeso.dart';


class Objetivos extends StatefulWidget {
  const Objetivos({super.key});

  @override
  State<Objetivos> createState() => _ObjetivosState();
}

class _ObjetivosState extends State<Objetivos> {
  // Se por algum motivo estiveres a usar bool? noutros sítios, isto protege.
  bool? melhorarAlimentacao;
  bool? melhorarHumor;
  bool? melhorarSono;
  bool? atvFisica;
  bool? redStress;
  bool? ganharEnergia;
  bool? outro;

  @override
  void initState() {
    super.initState();
    // Inicializa explicitamente (evita qualquer null)
    melhorarAlimentacao = false;
    melhorarHumor = false;
    melhorarSono = false;
    atvFisica = false;
    redStress = false;
    ganharEnergia = false;
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
                      'Indique o(s) seu(s) objetivos principais',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 32),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Melhorar Alimentação'),
                      value: melhorarAlimentacao ?? false,
                      onChanged: (v) => setState(() => melhorarAlimentacao = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Melhorar humor'),
                      value: melhorarHumor ?? false,
                      onChanged: (v) => setState(() => melhorarHumor = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Melhorar sono'),
                      value: melhorarSono ?? false,
                      onChanged: (v) => setState(() => melhorarSono = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Aumentar atividade física'),
                      value: atvFisica ?? false,
                      onChanged: (v) => setState(() => atvFisica = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Reduzir Stress'),
                      value: redStress ?? false,
                      onChanged: (v) => setState(() => redStress = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ganhar energia'),
                      value: ganharEnergia ?? false,
                      onChanged: (v) => setState(() => ganharEnergia = v ?? false),
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
                            MaterialPageRoute(builder: (_) => const Dieta()),
                          );
                        },
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Objpeso()),
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
