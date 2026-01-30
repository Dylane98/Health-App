import 'package:flutter/material.dart';
import 'package:higia/login.dart';
import 'package:higia/registry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:higia/services/service_locator.dart';

import 'dadosRegisto.dart';
import 'package:higia/recover_password.dart'; // <- se tiveres esta página

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://uhortitqkefkfppnfifw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVob3J0aXRxa2Vma2ZwcG5maWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU4ODg5ODksImV4cCI6MjA4MTQ2NDk4OX0.IsMCivRAyJaBgsaV7LKdynJ01fuwxSArJZpXda28_-Y',
    );
  } catch (e, st) {
    debugPrint('Supabase.initialize failed: $e\n$st');
    rethrow;
  }

  await initServiceLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  static const _azul = Color(0xFF1565C0);
  static const _azulClaro = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // LOGO
                    Image.asset(
                      'images/logo.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 14),

                    // TÍTULO
                    const Text(
                      'Welcome to\nHigia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 140, 179, 224),
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // CARD COM BOTÕES
                    Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 42, 158, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Começar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // LOGIN
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Login(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('Login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _azul,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // REGISTAR
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RegisterPage(data: RegistrationData()),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person_add_alt_1),
                              label: const Text('Registar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                side: const BorderSide(
                                  color: _azul,
                                  width: 1.6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // RECUPERAR PASSWORD (LINK)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Recoverpassword(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Recuperar Password',
                                style: TextStyle(
                                  color: _azul,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'HIGIA • Cuida de ti todos os dias',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
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
