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
              backgroundColor: const Color(0xFFE3F2FD),
              foregroundColor: Colors.red,
              elevation: 0,
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

                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD), // 🔵 igual ao resto
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
                                Icon(Icons.person, color: Color(0xFF1565C0)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Perfil",
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
                              "Gere a tua conta e as tuas opções.",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // BOTÕES
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
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChangePassword(
                                      idutilizador: idutilizador,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.lock_reset),
                              label: const Text("Alterar password"),
                            ),
                            const SizedBox(height: 12),

                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        Menu(idutilizador: idutilizador),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1565C0),
                                side: const BorderSide(
                                  color: Color(0xFF1565C0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.home),
                              label: const Text("Voltar ao menu"),
                            ),
                            const SizedBox(height: 12),

                            OutlinedButton.icon(
                              onPressed: () => _logout(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.logout),
                              label: const Text("Terminar sessão"),
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
