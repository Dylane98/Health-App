import 'package:flutter/material.dart';
import 'package:higia/atvPreferida.dart';
import 'package:higia/regEmail.dart';

class Motivacao extends StatefulWidget {
  const Motivacao({super.key});

  @override
  State<Motivacao> createState() => _MotivacaoState();
}

class _MotivacaoState extends State<Motivacao> {
  String? motivacao;

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
                  Image.asset(
                    'images/logo2.png',
                    height: 60,
                    width: 120,
                  ),
                  const SizedBox(height: 32),
                  // ✅ Container separado com radios alinhados à esquerda
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
                          onChanged: (value) {
                            setState(() {
                              motivacao = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Baixa - Alguma disposição ocasional'),
                          value: 'baixa',
                          groupValue: motivacao,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              motivacao = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Moderada - Consegue avançar'),
                          value: 'moderada',
                          groupValue: motivacao,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              motivacao = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Alta - Boa energia'),
                          value: 'alta',
                          groupValue: motivacao,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              motivacao = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Muito alta - Total empenho'),
                          value: 'muitoAlta',
                          groupValue: motivacao,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              motivacao = value;
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
                            MaterialPageRoute(builder: (_) => const Atvpreferida()),
                          );
                        },
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegEmail()),
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
