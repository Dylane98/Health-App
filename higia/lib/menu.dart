import 'package:flutter/material.dart';
import 'package:higia/profile.dart';

class Menu extends StatelessWidget {
  final int idutilizador;
  const Menu({super.key, required this.idutilizador});

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
                    builder: (_) => Profile(idutilizador: idutilizador),
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
                        debugPrint('The image button has been tapped');
                      },
                      child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Image.asset('images/sono.png'),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/logo2.png', height: 70),
                        const SizedBox(width: 26),
                        Image.asset('images/logo2.png', height: 70),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/logo2.png', height: 70),
                        const SizedBox(width: 26),
                        Image.asset('images/logo2.png', height: 70),
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
