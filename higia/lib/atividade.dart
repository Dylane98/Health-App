import 'package:flutter/material.dart';
import 'package:higia/menu.dart';

class atividade extends StatelessWidget {
  final int idutilizador;

  atividade({super.key, required this.idutilizador});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Menu(idutilizador: idutilizador),
                ),
              );
            },
          ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Image.asset('images/atividade.png', height: 70),
                    const SizedBox(height: 52),
                    // ... (rest unchanged) ...
                    Padding(padding: const EdgeInsets.only(left: 131)),
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
