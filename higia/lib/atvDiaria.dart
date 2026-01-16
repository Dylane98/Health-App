import 'package:flutter/material.dart';
import 'package:higia/atvPreferida.dart';
import 'package:higia/objPeso.dart';


class atvDiaria extends StatefulWidget {
  const atvDiaria({super.key});

  @override
  State<atvDiaria> createState() => _atvDiariaState();
}

class _atvDiariaState extends State<atvDiaria> {
  String? atvDiaria;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  Image.asset(
                    'images/logo2.png',
                    height: 60,
                    width: 120,
                  ),
                  SizedBox(height: 32),
                  // ✅ Container separado com radios alinhados à esquerda
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Indique o seu nível de atividade diária.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 32),
                        RadioListTile<String>(
                          title: const Text('Sedentário - Menos de 5000 passos p/ dia'),
                          value: 'sedentario',
                          groupValue: atvDiaria,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              atvDiaria = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Ativo - 8000 a 10000 passos p/ dia'),
                          value: 'ativo',
                          groupValue: atvDiaria,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              atvDiaria = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Ideal - 40 a 60 minutos de atividade física diária'),
                          value: 'ideal',
                          groupValue: atvDiaria,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              atvDiaria = value;
                            });
                          },
                        ),
                      ],
                    ),
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
                            MaterialPageRoute(builder: (_) => const Objpeso()),
                          );
                        },
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Atvpreferida()),
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
      ),
    );
  }
}
