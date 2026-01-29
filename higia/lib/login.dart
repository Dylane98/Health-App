import 'package:flutter/material.dart';
import 'package:higia/menu.dart';
import 'package:higia/recover_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _aEntrar = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _erroCredenciais() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro', textAlign: TextAlign.center),
        content: const Text(
          'Credenciais incorretas.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loginSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _aEntrar = true);
    final client = Supabase.instance.client;

    try {
      final username = _username.text.trim();
      final password = _password.text;

      final res = await client
          .from('utilizador')
          .select('idutilizador')
          .eq('username', username)
          .eq('password', password)
          .limit(1);

      if (!mounted) return;

      if (res.isNotEmpty) {
        final id = res.first['idutilizador'] as int;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Menu(idutilizador: id)),
        );
      } else {
        _erroCredenciais();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao iniciar sessão: $e')),
      );
    } finally {
      if (mounted) setState(() => _aEntrar = false);
    }
  }

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
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _username,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nome de utilizador',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Indicar o nome de utilizador'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Indicar a password' : null,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Recoverpassword(),
                              ),
                            );
                          },
                          child: const Text('Recuperar Password'),
                        ),
                        ElevatedButton(
                          onPressed: _aEntrar ? null : _loginSubmit,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                          child: Text(
                            _aEntrar ? 'A entrar...' : 'Iniciar sessão',
                          ),
                        ),
                      ],
                    ),
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
