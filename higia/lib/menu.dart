import 'package:flutter/material.dart';
import 'package:higia/profile.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/saude.dart';
import 'Passos.dart';
import 'Sono.dart';

class Menu extends StatelessWidget {
  final RegistrationData reg = RegistrationData();
  final int idutilizador;

  Menu({super.key, required this.idutilizador});

  Widget _buildTile(BuildContext context, {required String asset, required VoidCallback? onTap}) {
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
            boxShadow: [
              BoxShadow(
                color: const Color(0x3F000000),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTileWithoutShadow(BuildContext context, {required String asset, required VoidCallback? onTap}) {
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
                MaterialPageRoute(builder: (_) => Profile(idutilizador: idutilizador)),
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
                  const SizedBox(height: 24),
                  Image.asset('images/logo2.png', height: 70),
                  const SizedBox(height: 20),

                  // Grid of tiles using Wrap for responsiveness
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                MaterialPageRoute(builder: (_) => Passos(data: reg, idutilizador: idutilizador,)),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/Saude.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Saude(data: reg, idutilizador: idutilizador)),
                              );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/sono.png',
                            onTap: () {
                              Navigator.push(
                                  context,
                              MaterialPageRoute(builder: (_) => Sono(idutilizador: idutilizador))
                                  );
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/meditacao.png',
                            onTap: () {
                              // TODO: navigate to meditation page
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/alimentacao.png',
                            onTap: () {
                              // TODO: navigate to nutrition page
                            },
                          ),
                          _buildTile(
                            context,
                            asset: 'images/atividade.png',
                            onTap: () {
                              // TODO: navigate to activities page
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
