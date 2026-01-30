import 'package:flutter/material.dart';
import 'package:higia/menu.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/user_service.dart';

class RegEmailPage extends StatefulWidget {
  final RegistrationData data;
  const RegEmailPage({super.key, required this.data});

  @override
  State<RegEmailPage> createState() => _RegEmailPageState();
}

class _RegEmailPageState extends State<RegEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confpassword = TextEditingController();

  bool _guarda = false;
  final userService = getIt<UserService>();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confpassword.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blueGrey.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
    );
  }

  void _sucesso(int idutilizador) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Parabéns', textAlign: TextAlign.center),
        content: const Text(
          'Conta de utilizador criada com sucesso!',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Menu(idutilizador: idutilizador),
                ),
              );
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarESalvar() async {
    setState(() => _guarda = true);

    try {
      final created = await userService.createUser(widget.data);
      if (created == null) throw Exception('Failed to create user');

      widget.data.idutilizador = created;
      if (!mounted) return;
      _sucesso(created);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao guardar: $e')));
    } finally {
      if (mounted) setState(() => _guarda = false);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final password = _password.text;
    final confpassword = _confpassword.text;

    if (password != confpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As passwords não coincidem')),
      );
      return;
    }

    widget.data.username = _username.text.trim();
    widget.data.email = _email.text.trim();
    widget.data.password = password;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar', textAlign: TextAlign.center),
        content: const Text(
          'Queres guardar os dados e criar a conta?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _guarda
                ? null
                : () {
                    Navigator.pop(ctx);
                    _confirmarESalvar();
                  },
            child: const Text('Confirmar'),
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

                    // Cabeçalho
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
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_add_alt_1,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Criar conta",
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
                              "Define o teu utilizador, email e password.",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Form
                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _username,
                                decoration: _dec(
                                  'Nome de utilizador',
                                  Icons.person,
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (v) =>
                                    (v == null || v.trim().length < 6)
                                    ? 'mínimo 6 caracteres'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _email,
                                decoration: _dec(
                                  'Endereço de email',
                                  Icons.email_outlined,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Indique o email';
                                  }
                                  final re = RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  );
                                  return re.hasMatch(v.trim())
                                      ? null
                                      : 'email inválido';
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _password,
                                decoration: _dec(
                                  'Password',
                                  Icons.lock_outline,
                                ),
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v == null || v.length < 8)
                                    ? 'mínimo 8 caracteres'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confpassword,
                                decoration: _dec(
                                  'Confirmar password',
                                  Icons.lock_reset_outlined,
                                ),
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) =>
                                    _guarda ? null : _submit(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Confirme a password';
                                  }
                                  if (v != _password.text) {
                                    return 'As passwords não coincidem';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Dica
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.info_outline, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'A password deve ter pelo menos 8 caracteres.',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              // Botões
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF1565C0),
                                    ),
                                    onPressed: _guarda
                                        ? null
                                        : () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Anterior'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _guarda ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1565C0),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    icon: _guarda
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.arrow_forward),
                                    label: Text(
                                      _guarda ? 'A guardar...' : 'Seguinte',
                                    ),
                                  ),
                                ],
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
