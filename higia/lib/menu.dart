import 'package:flutter/material.dart';
import 'package:higia/profile.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/relaxamento.dart';
import 'package:higia/saude.dart';
import 'package:higia/Sono.dart';
import 'package:higia/atividade.dart';
import 'package:higia/Passos.dart';
import 'package:higia/Alimentacao.dart';

class Menu extends StatelessWidget {
  final RegistrationData reg = RegistrationData();
  final int idutilizador;

  Menu({super.key, required this.idutilizador});

  // ---------- FRASE DE MOTIVAÇÃO ----------
  String _fraseMotivacaoDoDia() {
    final frases = [
      "Pequenos passos todos os dias fazem a diferença.",
      "Hoje é um bom dia para cuidares de ti.",
      "Consistência é mais importante do que perfeição.",
      "Respira fundo. Estás no caminho certo.",
      "Faz algo hoje pelo teu bem-estar.",
      "O teu corpo agradece cada escolha saudável.",
      "Um dia de cada vez. Continua.",
      "Mesmo pouco já é progresso.",
      "A tua saúde é prioridade.",
      "Cuida de ti como cuidarias de alguém que amas.",
    ];

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return frases[dayOfYear % frases.length];
  }

  Widget _cardMotivacao() {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _fraseMotivacaoDoDia(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- TILES (IGUAIS AOS ORIGINAIS) ----------
  Widget _buildTile(
    BuildContext context, {
    required String asset,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTileWithoutShadow(
    BuildContext context, {
    required String asset,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Profile(idutilizador: idutilizador),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  Image.asset('images/logo2.png', height: 95),
                  const SizedBox(height: 35),

                  // ⭐ FRASE DE MOTIVAÇÃO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _cardMotivacao(),
                  ),

                  const SizedBox(height: 35),

                  // ---------- GRID ORIGINAL ----------
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          _buildTileWithoutShadow(
                            context,
                            asset: 'images/passos.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Passos(
                                    data: reg,
                                    idutilizador: idutilizador,
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/Saude.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Saude(
                                    data: reg,
                                    idutilizador: idutilizador,
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/sono.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Sono(idutilizador: idutilizador),
                                ),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/meditacao.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Relaxamento(idutilizador: idutilizador),
                                ),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/alimentacao.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Alimentacao(idutilizador: idutilizador),
                                ),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/atividade.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      atividade(idutilizador: idutilizador),
                                ),
                              );
                            },
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
    );
  }
}
