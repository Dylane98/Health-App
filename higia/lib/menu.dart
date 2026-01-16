import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

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
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background2.png'),
              fit: BoxFit.cover,
            )
          ),
          child: SafeArea(
            child: Center(
              child: SizedBox(
                width: 500, // mantém a tua estrutura
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // LOGO (centrado abaixo da AppBar)
                    Image.asset(
                      'images/logo2.png',
                      height: 70,
                    ),

                    const SizedBox(height: 120),

                    // BOTÃO 1 (centrado)
                    GestureDetector(
                      onTap: () {
                        debugPrint('The image button has been tapped');
                      },
                      child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Image.asset('images/sono.png')
                      ),
                    ),
                    

                    const SizedBox(height: 26),

                    // LINHA 1 (2 botões)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/logo2.png',
                          height: 70,
                        ),
                        const SizedBox(width: 26),
                        Image.asset(
                          'images/logo2.png',
                          height: 70,
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // LINHA 2 (2 botões)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/logo2.png',
                          height: 70,
                        ),
                        const SizedBox(width: 26),
                        Image.asset(
                          'images/logo2.png',
                          height: 70,
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Exemplo: botão para ir ao Menu (se quiseres manter)
                    
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}
