import 'package:flutter/material.dart';
import 'package:higia/objPeso.dart';
import 'package:higia/dadosRegisto.dart';

class Objetivos extends StatefulWidget {
  final RegistrationData data;
  const Objetivos({super.key, required this.data});

  @override
  State<Objetivos> createState() => _ObjetivosState();
}

class _ObjetivosState extends State<Objetivos> {
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

  Widget _check({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D47A1),
          ),
        ),
        secondary: Icon(icon, color: const Color(0xFF1565C0)),
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
                                  Icons.flag_outlined,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Objetivos",
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
                              "Indica os teus objetivos principais (podes escolher mais do que um).",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

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
                            _check(
                              title: "Melhorar alimentação",
                              value: melhorarAlimentacao,
                              icon: Icons.restaurant_menu,
                              onChanged: (v) => setState(
                                () => melhorarAlimentacao = v ?? false,
                              ),
                            ),
                            _check(
                              title: "Melhorar humor",
                              value: melhorarHumor,
                              icon: Icons.emoji_emotions_outlined,
                              onChanged: (v) =>
                                  setState(() => melhorarHumor = v ?? false),
                            ),
                            _check(
                              title: "Melhorar sono",
                              value: melhorarSono,
                              icon: Icons.bedtime_outlined,
                              onChanged: (v) =>
                                  setState(() => melhorarSono = v ?? false),
                            ),
                            _check(
                              title: "Aumentar atividade física",
                              value: atvFisica,
                              icon: Icons.directions_run,
                              onChanged: (v) =>
                                  setState(() => atvFisica = v ?? false),
                            ),
                            _check(
                              title: "Reduzir stress",
                              value: redStress,
                              icon: Icons.spa_outlined,
                              onChanged: (v) =>
                                  setState(() => redStress = v ?? false),
                            ),
                            _check(
                              title: "Ganhar energia",
                              value: ganharEnergia,
                              icon: Icons.bolt,
                              onChanged: (v) =>
                                  setState(() => ganharEnergia = v ?? false),
                            ),
                            _check(
                              title: "Outro",
                              value: outro,
                              icon: Icons.more_horiz,
                              onChanged: (v) =>
                                  setState(() => outro = v ?? false),
                            ),

                            const SizedBox(height: 10),

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
                                  onPressed: _seguinte,
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
