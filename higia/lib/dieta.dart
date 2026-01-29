import 'package:flutter/material.dart';
import 'package:higia/objetivos.dart';
import 'package:higia/dadosRegisto.dart';

class Dieta extends StatefulWidget {
  final RegistrationData data;
  const Dieta({super.key, required this.data});

  @override
  State<Dieta> createState() => _DietaState();
}

class _DietaState extends State<Dieta> {
  late bool alimentacaoVariada;
  late bool vegetariano;
  late bool semLactose;
  late bool semGluten;
  late bool carne;
  late bool peixe;

  late final int idutilizador;
  @override
  void initState() {
    super.initState();
    alimentacaoVariada = widget.data.alimentacaoVariada;
    vegetariano = widget.data.vegetariano;
    semLactose = widget.data.semLactose;
    semGluten = widget.data.semGluten;
    carne = widget.data.carne;
    peixe = widget.data.peixe;
  }

  void _seguinte() {
    widget.data.alimentacaoVariada = alimentacaoVariada;
    widget.data.vegetariano = vegetariano;
    widget.data.semLactose = semLactose;
    widget.data.semGluten = semGluten;
    widget.data.carne = carne;
    widget.data.peixe = peixe;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Objetivos(data: widget.data)),
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
                      'Indique o seu tipo de dieta',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Alimentação variada'),
                      value: alimentacaoVariada,
                      onChanged: (v) => setState(() => alimentacaoVariada = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Vegetariano'),
                      value: vegetariano,
                      onChanged: (v) => setState(() => vegetariano = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sem lactose'),
                      value: semLactose,
                      onChanged: (v) => setState(() => semLactose = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sem glúten'),
                      value: semGluten,
                      onChanged: (v) => setState(() => semGluten = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Carne'),
                      value: carne,
                      onChanged: (v) => setState(() => carne = v ?? false),
                    ),
                    CheckboxListTile(
                      tristate: false,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Peixe'),
                      value: peixe,
                      onChanged: (v) => setState(() => peixe = v ?? false),
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
