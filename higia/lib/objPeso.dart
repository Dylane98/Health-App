import 'package:flutter/material.dart';
import 'package:higia/atvDiaria.dart';
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

  Widget _radio({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D47A1),
          ),
        ),
        secondary: Icon(icon, color: const Color(0xFF1565C0)),
        value: value,
        groupValue: peso,
        onChanged: (v) => setState(() => peso = v),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        activeColor: const Color(0xFF1565C0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Image.asset('images/logo2.png', width: 190),
                    const SizedBox(height: 18),

                    // Cabeçalho
                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.monitor_weight_outlined,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Objetivo de peso",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Tem algum objetivo relacionado com o peso?",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Opções
                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            _radio(
                              title: "Perder peso",
                              value: "perderPeso",
                              icon: Icons.trending_down,
                            ),
                            _radio(
                              title: "Manter peso",
                              value: "manterPeso",
                              icon: Icons.horizontal_rule,
                            ),
                            _radio(
                              title: "Ganhar peso",
                              value: "ganharPeso",
                              icon: Icons.trending_up,
                            ),
                            _radio(
                              title: "Sem objetivo",
                              value: "semObjetivo",
                              icon: Icons.not_interested,
                            ),

                            const SizedBox(height: 10),

                            // Botões
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF1565C0),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Anterior'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _next,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1565C0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Seguinte'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
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
