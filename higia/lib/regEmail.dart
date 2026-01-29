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

  // Helper: deeply serialize DateTime objects in maps/lists to ISO strings
  dynamic _serializeForSupabase(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toIso8601String();
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _serializeForSupabase(v)));
    }
    if (value is List) {
      return value.map((e) => _serializeForSupabase(e)).toList();
    }
    return value;
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confpassword.dispose();
    super.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao guardar: $e')),
      );
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
      appBar: AppBar(backgroundColor: Colors.transparent),
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
            Image.asset('images/logo2.png', width: 160),
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
                            decoration: const InputDecoration(
                              labelText: 'Nome de utilizador',
                            ),
                            validator: (v) => (v == null || v.trim().length < 6)
                                ? 'mínimo 6 caracteres'
                                : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Endereço de email',
                            ),
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
                            validator: (v) => (v == null || v.length < 8)
                                ? 'mínimo 8 caracteres'
                                : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confpassword,
                            decoration: const InputDecoration(
                              labelText: 'Confirmar password',
                            ),
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Confirme a password';
                              if (v != _password.text) return 'As passwords não coincidem';
                              return null;
                            },
                          ),
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                onPressed: _guarda ? null : () => Navigator.pop(context),
                                child: const Text('Anterior'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _guarda ? null : _submit,
                                child: Text(_guarda ? 'A guardar...' : 'Seguinte'),
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
