import 'package:flutter/material.dart';
import 'package:higia/login.dart';

class Recoverpassword extends StatefulWidget {
  const Recoverpassword({super.key});

  @override
  State<Recoverpassword> createState() => _RecoverpasswordState();
}

class _RecoverpasswordState extends State<Recoverpassword> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _aEnviar = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Future<void> _recuperar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _aEnviar = true);

    // ✅ Aqui depois ligas à lógica real de recuperação (email, supabase, etc.)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _aEnviar = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verifica o teu email', textAlign: TextAlign.center),
        content: Text(
          'Se o email existir, vais receber instruções para recuperar a password:\n\n${_email.text.trim()}',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            },
            child: const Text('OK'),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 14),
                    Image.asset('images/logo2.png', height: 80),
                    const SizedBox(height: 22),

                    Card(
                      elevation: 4,
                      color: const Color(
                        0xFFD6EAF8,
                      ), // azul mais escuro (como pediste)
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
                              Row(
                                children: const [
                                  Icon(Icons.lock_reset, size: 26),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Recuperar Password',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0D47A1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Indica o teu email e vamos enviar instruções.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                              const SizedBox(height: 18),

                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _dec('Email', Icons.email_outlined),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Indica o email';
                                  }
                                  final re = RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  );
                                  return re.hasMatch(v.trim())
                                      ? null
                                      : 'Email inválido';
                                },
                              ),

                              const SizedBox(height: 18),

                              ElevatedButton.icon(
                                onPressed: _aEnviar ? null : _recuperar,
                                icon: const Icon(Icons.send),
                                label: Text(
                                  _aEnviar
                                      ? 'A enviar...'
                                      : 'Recuperar Password',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextButton.icon(
                                onPressed: _aEnviar
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const Login(),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Voltar ao login'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
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
