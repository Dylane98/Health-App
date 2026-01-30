import 'package:flutter/material.dart';
import 'package:higia/menu.dart';
import 'package:higia/recover_password.dart';
import 'package:higia/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

/// =====================
/// MODEL
/// =====================
class LoginModel {
  bool aEntrar;
  String username;
  String password;

  LoginModel({this.aEntrar = false, this.username = "", this.password = ""});
}

/// =====================
/// CONTROLLER
/// =====================
class LoginController {
  final SupabaseClient client;

  LoginController({required this.client});

  Future<int?> autenticar({
    required String username,
    required String password,
  }) async {
    final res = await client
        .from('utilizador')
        .select('idutilizador')
        .eq('username', username)
        .eq('password', password)
        .limit(1);

    if (res.isNotEmpty) {
      return res.first['idutilizador'] as int;
    }
    return null;
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late final LoginController controller;
  final LoginModel model = LoginModel();

  @override
  void initState() {
    super.initState();
    controller = LoginController(client: Supabase.instance.client);
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _alert(String titulo, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo, textAlign: TextAlign.center),
        content: Text(msg, textAlign: TextAlign.center),
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

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Future<void> _loginSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => model.aEntrar = true);

    try {
      final id = await controller.autenticar(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      if (id != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Menu(idutilizador: id)),
        );
      } else {
        _alert('Erro', 'Credenciais incorretas.');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao iniciar sessão: $e')));
    } finally {
      if (mounted) setState(() => model.aEntrar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Homepage()),
                (route) => false,
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
                width: 520,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Image.asset('images/logo2.png', height: 80),
                      const SizedBox(height: 18),

                      Card(
                        elevation: 4,
                        color: const Color(0xFFE3F2FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF0D47A1),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Iniciar sessão',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0D47A1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _usernameCtrl,
                                  decoration: _dec(
                                    'Nome de utilizador',
                                    Icons.person_outline,
                                  ),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                      ? 'Indica o nome de utilizador'
                                      : null,
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: _passwordCtrl,
                                  decoration: _dec(
                                    'Password',
                                    Icons.key_outlined,
                                  ),
                                  obscureText: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Indica a password'
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: model.aEntrar
                                        ? null
                                        : _loginSubmit,
                                    icon: const Icon(Icons.login),
                                    label: Text(
                                      model.aEntrar
                                          ? 'A entrar...'
                                          : 'Iniciar sessão',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color(0xFF0D47A1),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const Recoverpassword(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF0D47A1),
                                  ),
                                  child: const Text('Recuperar Password'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
