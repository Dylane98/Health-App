import 'package:flutter/material.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/regEmail.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/user_service.dart';

final userService = getIt<UserService>();

class Atvpreferida extends StatefulWidget {
  final RegistrationData data;
  const Atvpreferida({super.key, required this.data});

  @override
  State<Atvpreferida> createState() => _AtvpreferidaState();
}

class _AtvpreferidaState extends State<Atvpreferida> {
  late bool caminhadas;
  late bool corrida;
  late bool natacao;
  late bool passadeira;
  late bool outro;

  @override
  void initState() {
    super.initState();
    caminhadas = widget.data.caminhadas;
    corrida = widget.data.corrida;
    natacao = widget.data.natacao;
    passadeira = widget.data.passadeira;
    outro = widget.data.atvOutro;
  }

  Future<bool> _saveAtividade() async {
    widget.data.caminhadas = caminhadas;
    widget.data.corrida = corrida;
    widget.data.natacao = natacao;
    widget.data.passadeira = passadeira;
    widget.data.atvOutro = outro;

    try {
      final idAtv = await userService.fetchOrCreateAtividade(
        widget.data.nivelAtividadeDiaria,
        widget.data,
      );
      if (idAtv != null) widget.data.idAtividade = idAtv;
      return true;
    } catch (e) {
      debugPrint('Failed to save atividade: $e');
      return false;
    }
  }

  Future<void> _seguinte() async {
    widget.data.caminhadas = caminhadas;
    widget.data.corrida = corrida;
    widget.data.natacao = natacao;
    widget.data.passadeira = passadeira;
    widget.data.atvOutro = outro;

    await _saveAtividade();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegEmailPage(data: widget.data)),
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
                                  Icons.favorite_outline,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Atividade preferida",
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
                              "Indica a(s) tua(s) atividade(s) preferida(s).",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Conteúdo
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
                              title: "Caminhadas",
                              value: caminhadas,
                              icon: Icons.directions_walk,
                              onChanged: (v) =>
                                  setState(() => caminhadas = v ?? false),
                            ),
                            _check(
                              title: "Corrida",
                              value: corrida,
                              icon: Icons.directions_run,
                              onChanged: (v) =>
                                  setState(() => corrida = v ?? false),
                            ),
                            _check(
                              title: "Natação",
                              value: natacao,
                              icon: Icons.pool,
                              onChanged: (v) =>
                                  setState(() => natacao = v ?? false),
                            ),
                            _check(
                              title: "Passadeira",
                              value: passadeira,
                              icon: Icons.fitness_center,
                              onChanged: (v) =>
                                  setState(() => passadeira = v ?? false),
                            ),
                            _check(
                              title: "Outro",
                              value: outro,
                              icon: Icons.more_horiz,
                              onChanged: (v) =>
                                  setState(() => outro = v ?? false),
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
