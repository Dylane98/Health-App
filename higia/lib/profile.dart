import 'package:flutter/material.dart';
import 'package:higia/change_password.dart';
import 'package:higia/main.dart';
import 'package:higia/menu.dart';

class Profile extends StatelessWidget {
  final int idutilizador;
  const Profile({super.key, required this.idutilizador});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(idutilizador: idutilizador),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final int idutilizador;
  const ProfilePage({super.key, required this.idutilizador});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminar sessão', textAlign: TextAlign.center),
        content: const Text(
          'Tens a certeza que queres terminar a sessão?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainApp()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Terminar sessão'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChangePassword(idutilizador: idutilizador),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.lightBlue,
                ),
                child: const Text('Alterar password'),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.lightBlue,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Menu(idutilizador: idutilizador),
                    ),
                  );
                },
                child: const Text('Retroceder'),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () => _logout(context),
                child: const Text('Terminar sessão'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
