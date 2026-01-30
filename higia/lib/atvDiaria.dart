import 'package:flutter/material.dart';
import 'package:higia/atvPreferida.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/user_service.dart';

final userService = getIt<UserService>();

class atvDiaria extends StatefulWidget {
  final RegistrationData data;
  const atvDiaria({super.key, required this.data});

  @override
  State<atvDiaria> createState() => _atvDiariaState();
}

class _atvDiariaState extends State<atvDiaria> {
  String? nivel;

  @override
  void initState() {
    super.initState();
    nivel = widget.data.nivelAtividadeDiaria;
  }

  Future<void> _saveAndNext() async {
    widget.data.nivelAtividadeDiaria = nivel;

    try {
      final id = await userService.fetchOrCreateAtividade(nivel, widget.data);
      if (id != null) widget.data.idAtividade = id;
    } catch (_) {}

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Atvpreferida(data: widget.data)),
    );
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blueGrey.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('images/logo2.png', height: 70),
                    const SizedBox(height: 24),

                    /// 🔹 CARD PRINCIPAL
                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.directions_walk,
                                  size: 26,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Atividade diária',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Indica o teu nível de atividade diária.',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 20),

                            /// 🔽 DROPDOWN (SEM OVERFLOW)
                            DropdownButtonFormField<String>(
                              value: nivel,
                              isExpanded: true,
                              decoration: _dec(
                                'Nível de atividade diária',
                                Icons.insights_outlined,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'sedentario',
                                  child: Text(
                                    'Sedentário - Menos de 5000 passos/dia',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ativo',
                                  child: Text(
                                    'Ativo - 8000 a 10000 passos/dia',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ideal',
                                  child: Text(
                                    'Ideal - 40 a 60 min de atividade diária',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              selectedItemBuilder: (context) {
                                const textos = [
                                  'Sedentário - Menos de 5000 passos/dia',
                                  'Ativo - 8000 a 10000 passos/dia',
                                  'Ideal - 40 a 60 min de atividade diária',
                                ];
                                return textos
                                    .map(
                                      (t) => Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          t,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList();
                              },
                              onChanged: (v) => setState(() => nivel = v),
                            ),

                            const SizedBox(height: 14),

                            /// ℹ️ DICA
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.info_outline, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Escolhe a opção que mais se aproxima do teu dia a dia.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// 🔘 BOTÕES
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Anterior'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1565C0),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: nivel == null ? null : _saveAndNext,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Seguinte'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
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
