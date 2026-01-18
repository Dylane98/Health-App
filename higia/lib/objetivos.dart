import 'package:flutter/material.dart';
import 'package:higia/dieta.dart';
import 'package:higia/objPeso.dart';
import 'package:higia/dadosRegisto.dart';


class Objetivos extends StatefulWidget {
  final RegistrationData data;
  const Objetivos({super.key, required this.data});

  @override
  State<Objetivos> createState() => _ObjetivosState();
}

class _ObjetivosState extends State<Objetivos> {
  // Se por algum motivo estiveres a usar bool? noutros sítios, isto protege.
  late bool melhorarAlimentacao;
  late bool melhorarHumor;
  late bool melhorarSono;
  late bool atvFisica;
  late bool redStress;
  late bool ganharEnergia;
  late bool outro;

  @override
  void initState() {
    super.initState();
    melhorarAlimentacao = widget.data.melhorarAlimentacao;
    melhorarHumor = widget.data.melhorarHumor;
    melhorarSono = widget.data.melhorarSono;
    atvFisica = widget.data.atvFisica;
    redStress = widget.data.redStress;
    ganharEnergia = widget.data.ganharEnergia;
    outro = widget.data.outro;
  }

  void _seguinte() {
    widget.data.melhorarAlimentacao = melhorarAlimentacao;
    widget.data.melhorarHumor = melhorarHumor;
    widget.data.melhorarSono = melhorarSono;
    widget.data.atvFisica = atvFisica;
    widget.data.redStress = redStress;
    widget.data.ganharEnergia = ganharEnergia;
    widget.data.outro = outro;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Objpeso(data: widget.data)),
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
                      'Indique o(s) seu(s) objetivos principais',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 32),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Melhorar Alimentação'),
                      value: melhorarAlimentacao,
                      onChanged: (v) => setState(() => melhorarAlimentacao = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Melhorar humor'),
                      value: melhorarHumor,
                      onChanged: (v) => setState(() => melhorarHumor = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Melhorar sono'),
                      value: melhorarSono,
                      onChanged: (v) => setState(() => melhorarSono = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Aumentar atividade física'),
                      value: atvFisica,
                      onChanged: (v) => setState(() => atvFisica = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Reduzir Stress'),
                      value: redStress,
                      onChanged: (v) => setState(() => redStress = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ganhar energia'),
                      value: ganharEnergia,
                      onChanged: (v) => setState(() => ganharEnergia = v ?? false),
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
