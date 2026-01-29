import 'package:flutter/material.dart';
import 'package:higia/atvDiaria.dart';
import 'package:higia/profile.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/saude.dart';

class Menu extends StatelessWidget {
 final RegistrationData reg = RegistrationData();
  final int idutilizador;
  Menu({super.key, required this.idutilizador});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Profile(idutilizador: idutilizador)
                  ),
                );
              },
            )
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
              child: SizedBox(
                width: 500,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Image.asset('images/logo2.png', height: 70),

                    const SizedBox(height: 120),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Saude(data: reg, idutilizador: idutilizador),
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/Saude.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/sono.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 50),
                        Container(
                          width: 140,
                          height: 140,

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/meditacao.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/alimentacao.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/atividade.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
