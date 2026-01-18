import 'package:flutter/material.dart';
import 'package:higia/atvDiaria.dart';
import 'package:higia/objetivos.dart';
import 'package:higia/dadosRegisto.dart';

class Objpeso extends StatefulWidget {
  final RegistrationData data;
  const Objpeso({super.key, required this.data});

  @override
  State<Objpeso> createState() => _ObjpesoState();
}

class _ObjpesoState extends State<Objpeso> {
  String? peso;

  @override
  void initState() {
    super.initState();
    peso = widget.data.objetivoPeso;
  }

  void _next() {
    widget.data.objetivoPeso = peso;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => atvDiaria(data: widget.data)),
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
                Image.asset('images/logo2.png', height: 60, width: 120),
                const SizedBox(height: 48),
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
                        onChanged: (value) => setState(() => peso = value),
                      ),
                      RadioListTile<String>(
                        title: const Text('Manter peso'),
                        value: 'manterPeso',
                        groupValue: peso,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) => setState(() => peso = value),
                      ),
                      RadioListTile<String>(
                        title: const Text('Ganhar peso'),
                        value: 'ganharPeso',
                        groupValue: peso,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) => setState(() => peso = value),
                      ),
                      RadioListTile<String>(
                        title: const Text('Sem objetivo'),
                        value: 'semObjetivo',
                        groupValue: peso,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) => setState(() => peso = value),
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