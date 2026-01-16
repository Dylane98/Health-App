import 'package:flutter/material.dart';
import 'package:higia/atvDiaria.dart';
import 'package:higia/objetivos.dart';

class Objpeso extends StatefulWidget {
  const Objpeso({super.key});

  @override
  State<Objpeso> createState() => _ObjpesoState();
}

class _ObjpesoState extends State<Objpeso> {
  String? peso;

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
                  const SizedBox(height: 48),
                  // ✅ Container separado com radios alinhados à esquerda
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tem algum objetivo relacionado com o peso?',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 32),
                        RadioListTile<String>(
                          title: const Text('Perder peso'),
                          value: 'perderPeso',
                          groupValue: peso,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              peso = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Manter peso'),
                          value: 'manterPeso',
                          groupValue: peso,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              peso = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Ganhar peso'),
                          value: 'ganharPeso',
                          groupValue: peso,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              peso = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Sem objetivo'),
                          value: 'semObjetivo',
                          groupValue: peso,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              peso = value;
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
                            MaterialPageRoute(builder: (_) => const Objetivos()),
                          );
                        },
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const atvDiaria()),
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
