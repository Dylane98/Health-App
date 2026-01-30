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

  Widget _check({
    required String text,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF1565C0),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0D47A1),
        ),
      ),
      value: value,
      onChanged: onChanged,
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
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Image.asset('images/logo2.png', height: 80),
                    const SizedBox(height: 24),

                    // ---------- CARD PRINCIPAL ----------
                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD), // 🔵 azul do menu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Indique o seu tipo de dieta',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(height: 16),

                            _check(
                              text: 'Alimentação variada',
                              value: alimentacaoVariada,
                              onChanged: (v) => setState(
                                () => alimentacaoVariada = v ?? false,
                              ),
                            ),
                            _check(
                              text: 'Vegetariano',
                              value: vegetariano,
                              onChanged: (v) =>
                                  setState(() => vegetariano = v ?? false),
                            ),
                            _check(
                              text: 'Sem lactose',
                              value: semLactose,
                              onChanged: (v) =>
                                  setState(() => semLactose = v ?? false),
                            ),
                            _check(
                              text: 'Sem glúten',
                              value: semGluten,
                              onChanged: (v) =>
                                  setState(() => semGluten = v ?? false),
                            ),
                            _check(
                              text: 'Carne',
                              value: carne,
                              onChanged: (v) =>
                                  setState(() => carne = v ?? false),
                            ),
                            _check(
                              text: 'Peixe',
                              value: peixe,
                              onChanged: (v) =>
                                  setState(() => peixe = v ?? false),
                            ),

                            const SizedBox(height: 28),

                            // ---------- BOTÕES ----------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Anterior',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _seguinte,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1565C0),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Seguinte'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
