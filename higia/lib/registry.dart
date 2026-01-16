import 'package:flutter/material.dart';
import 'package:higia/dieta.dart';
import 'package:higia/main.dart';

void main() => runApp(const Registry());

class Registry extends StatelessWidget {
  const Registry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _altura = TextEditingController();
  final _peso = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    _altura.dispose();
    _peso.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Dieta()),
      );

      _nome.clear();
      _altura.clear();
      _peso.clear();
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

            // 🔹 LOGO FIXO
            Image.asset(
              'images/logo2.png',
              width: 160,
            ),

            // 🔹 FORMULÁRIO CENTRADO NO ESPAÇO RESTANTE
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
                            controller: _nome,
                            decoration:
                                const InputDecoration(labelText: 'Nome'),
                            validator: (n) {
                              if (n == null || n.trim().isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _altura,
                            decoration: const InputDecoration(
                                labelText: 'Altura em cm'),
                            keyboardType: TextInputType.number,
                            validator: (a) {
                              if (a == null || a.trim().isEmpty) {
                                return 'Campo obrigatório';
                              }
                              final re = RegExp(r'^\d{3}$');
                              return re.hasMatch(a.trim())
                                  ? null
                                  : 'Altura inválida';
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _peso,
                            decoration:
                                const InputDecoration(labelText: 'Peso'),
                            keyboardType: TextInputType.number,
                            validator: (p) {
                              if (p == null || p.trim().isEmpty) {
                                return 'Campo obrigatório';
                              }
                              final re = RegExp(r'^\d{2,3}$');
                              return re.hasMatch(p.trim())
                                  ? null
                                  : 'Peso inválido';
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
