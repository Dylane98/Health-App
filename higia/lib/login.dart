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

  static const _azul = Color(0xFF1565C0);
  static const _azulClaro = Color(0xFFE3F2FD);

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao iniciar sessão: $e')));
    } finally {
      if (mounted) setState(() => _aEntrar = false);
    }
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _azul),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blueGrey.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _azul, width: 2),
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
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.asset('images/logo2.png', height: 90),
                    const SizedBox(height: 18),

                    Card(
                      elevation: 4,
                      color: _azulClaro,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Iniciar sessão',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Entra com o teu nome de utilizador e password.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF0D47A1)),
                              ),
                              const SizedBox(height: 18),

                              TextFormField(
                                controller: _username,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: _dec(
                                  'Nome de utilizador',
                                  Icons.person_outline,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Indicar o nome de utilizador'
                                    : null,
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _password,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                onFieldSubmitted: (_) =>
                                    _aEntrar ? null : _loginSubmit(),
                                decoration: _dec(
                                  'Password',
                                  Icons.lock_outline,
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Indicar a password'
                                    : null,
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _aEntrar
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const Recoverpassword(),
                                            ),
                                          );
                                        },
                                  child: const Text(
                                    'Recuperar password',
                                    style: TextStyle(color: _azul),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              ElevatedButton(
                                onPressed: _aEntrar ? null : _loginSubmit,
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
                                child: Text(
                                  _aEntrar ? 'A entrar...' : 'Iniciar sessão',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Pequena nota (opcional)
                    const Text(
                      'HIGIA • Cuida de ti todos os dias',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.w600,
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
