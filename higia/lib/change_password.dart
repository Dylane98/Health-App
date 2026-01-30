import 'package:flutter/material.dart';
import 'package:higia/profile.dart';
import 'package:higia/services/auth_service.dart';

final _authService = AuthService();

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
    try {
      final ok = await _authService.changePassword(
        widget.idutilizador,
        atual,
        nova,
      );
      if (!mounted) return;
      if (!ok) {
        _alert('Erro', 'A password atual está incorreta.');
        return;
      }

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao alterar password: $e')));
    } finally {
      if (mounted) setState(() => _guarda = false);
    }
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.6),
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

                    Card(
                      elevation: 4,
                      color: const Color(0xFFE3F2FD), // 🔵 igual ao resto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.lock_reset,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Alterar password",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Escolhe uma password nova com pelo menos 8 caracteres.",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                            const SizedBox(height: 16),

                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _passwordAtual,
                                    decoration: _dec(
                                      "Password atual",
                                      Icons.lock_outline,
                                    ),
                                    obscureText: true,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Indique a password atual'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _novaPassword,
                                    decoration: _dec(
                                      "Nova password",
                                      Icons.lock,
                                    ),
                                    obscureText: true,
                                    validator: (v) =>
                                        (v == null || v.length < 8)
                                        ? 'mínimo 8 caracteres'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _confNovaPassword,
                                    decoration: _dec(
                                      "Confirmar nova password",
                                      Icons.lock,
                                    ),
                                    obscureText: true,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Confirme a nova password';
                                      }
                                      if (v != _novaPassword.text) {
                                        return 'As passwords novas não coincidem';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFF1565C0,
                                          ),
                                        ),
                                        onPressed: _guarda
                                            ? null
                                            : () => Navigator.pop(context),
                                        icon: const Icon(Icons.arrow_back),
                                        label: const Text('Anterior'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: _guarda
                                            ? null
                                            : _alterarPassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1565C0,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        icon: _guarda
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : const Icon(Icons.save),
                                        label: Text(
                                          _guarda ? 'A guardar...' : 'Guardar',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
