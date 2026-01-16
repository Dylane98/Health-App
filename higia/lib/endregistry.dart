import 'package:flutter/material.dart';
import 'package:higia/menu.dart';

class Endregistry extends StatelessWidget {
  const Endregistry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background2.png'),
              fit: BoxFit.cover,
            )
          ),
          child: Center(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo2.png',
                    height: 60,
                    width: 120,
                  ),
                  SizedBox(height: 32),
                  const Text(
                    'Parabéns \n Conclui o seu registo com sucesso',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 48),
                  IconButton.outlined(
                    onPressed: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Menu()),
                          );
                    },
                    icon: const Icon(Icons.home_outlined),
                    iconSize: 64,  
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
