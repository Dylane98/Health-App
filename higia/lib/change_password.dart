import 'package:flutter/material.dart';
import 'package:higia/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePassword extends StatefulWidget {
  final int idutilizador;
  const ChangePassword({super.key, required this.idutilizador});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordAtual = TextEditingController();
  final _novaPassword = TextEditingController();
  final _confNovaPassword = TextEditingController();

  bool _guarda = false;

  @override
  void dispose() {
    _passwordAtual.dispose();
    _novaPassword.dispose();
    _confNovaPassword.dispose();
    super.dispose();
  }

  void _alert(String titulo, String msg, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo, textAlign: TextAlign.center),
        content: Text(msg, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onOk?.call();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _alterarPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final atual = _passwordAtual.text;
    final nova = _novaPassword.text;
    final conf = _confNovaPassword.text;

    if (nova != conf) {
      _alert('Erro', 'As passwords novas não coincidem.');
      return;
    }

    setState(() => _guarda = true);
    final client = Supabase.instance.client;

    try {
      final res = await client
          .from('utilizador')
          .select('idutilizador')
          .eq('idutilizador', widget.idutilizador)
          .eq('password', atual)
          .limit(1);

      if (!mounted) return;

      if (res.isEmpty) {
        _alert('Erro', 'A password atual está incorreta.');
        return;
      }

      await client
          .from('utilizador')
          .update({'password': nova})
          .eq('idutilizador', widget.idutilizador);

      if (!mounted) return;

      _passwordAtual.clear();
      _novaPassword.clear();
      _confNovaPassword.clear();

      _alert(
        'Sucesso',
        'Password alterada com sucesso!',
        onOk: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Profile(idutilizador: widget.idutilizador),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar password: $e')),
      );
    } finally {
      if (mounted) setState(() => _guarda = false);
    }
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
                            controller: _passwordAtual,
                            decoration: const InputDecoration(labelText: 'Password atual'),
                            obscureText: true,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Indique a password atual' : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _novaPassword,
                            decoration: const InputDecoration(labelText: 'Nova password'),
                            obscureText: true,
                            validator: (v) => (v == null || v.length < 8)
                                ? 'mínimo 8 caracteres'
                                : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confNovaPassword,
                            decoration: const InputDecoration(labelText: 'Confirmar nova password'),
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Confirme a nova password';
                              if (v != _novaPassword.text) return 'As passwords novas não coincidem';
                              return null;
                            },
                          ),
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                                onPressed: _guarda ? null : () => Navigator.pop(context),
                                child: const Text('Anterior'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _guarda ? null : _alterarPassword,
                                child: Text(_guarda ? 'A guardar...' : 'Guardar'),
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
