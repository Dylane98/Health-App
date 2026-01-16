import 'package:flutter/material.dart';
import 'package:higia/main.dart';
import 'package:higia/menu.dart';

void main() => runApp(const RegEmail());

class RegEmail extends StatelessWidget {
  const RegEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegEmailPage(),
    );
  }
}

class RegEmailPage extends StatefulWidget {
  const RegEmailPage({super.key});

  @override
  State<RegEmailPage> createState() => _RegEmailPageState();
}

class _RegEmailPageState extends State<RegEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confpassword = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confpassword.dispose();
    super.dispose();
  }

  void _sucesso() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Parabéns', textAlign: TextAlign.center),
        content: const Text('Conta de utilizador criada com sucesso!', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Menu()),
              );
            },
            child: const Text('Ok', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _sucesso();
      _username.clear();
      _email.clear();
      _password.clear();
      _confpassword.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 64),

            Image.asset(
              'images/logo2.png',
              width: 160,
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _username,
                            decoration: const InputDecoration(labelText: 'Nome de utilizador'),
                            validator: (v) => (v == null || v.trim().length < 6) ? 'mínimo 6 caracteres' : null,
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(labelText: 'Endereço de email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Indique o email';
                              final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              return re.hasMatch(v.trim()) ? null : 'email inválido';
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _password,
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (v) => (v == null || v.length < 8) ? 'mínimo 8 caracteres' : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confpassword,
                            decoration: const InputDecoration(labelText: 'Confirmar password'),
                            obscureText: true,
                            validator: (v) => (v != _password.text) ? 'As passwords não coincidem' : null,
                          ),
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainApp(),
                                    ),
                                  );
                                },
                                child: const Text('Cancelar'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _submit,
                                child: const Text('Seguinte'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
