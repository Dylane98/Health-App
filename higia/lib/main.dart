import 'package:flutter/material.dart';
import 'package:higia/login.dart';
import 'package:higia/registry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uhortitqkefkfppnfifw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVob3J0aXRxa2Vma2ZwcG5maWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU4ODg5ODksImV4cCI6MjA4MTQ2NDk4OX0.IsMCivRAyJaBgsaV7LKdynJ01fuwxSArJZpXda28_-Y',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'images/logo.png',
              width: 277,
              height: 280,
              ),
            Text(
              'Welcome to \nHigia',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 50
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              child: const Text('Registar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              onPressed: () {},
              child: const Text('Recuperar Password'),
            ),

          ],
        ),
      ),
      )
    );
  }
}