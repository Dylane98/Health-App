import 'package:flutter/material.dart';
import 'package:higia/dieta.dart';
import 'package:higia/main.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _sobrenome = TextEditingController();
  final _altura = TextEditingController();
  final _peso = TextEditingController();
  final _alergias = TextEditingController();

  List<String> _sexos = [];
  String? _sexoSelecionado;
  bool _aCarregarSexos = true;

  @override
  void initState() {
    super.initState();
    _carregarSexos();
  }

  Future<void> _carregarSexos() async {
    try {
      final client = Supabase.instance.client;

      // RPC que devolve os valores do enum
      final res = await client.rpc('sexo');

      final lista = (res as List)
        .map((e) => e.toString())
        .toList();

        if (!mounted) return;
        setState(() {
          _sexos = lista;
          _aCarregarSexos = false;
        });
      } catch (e) {
      if (!mounted) return;
      setState(() => _aCarregarSexos = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar sexos: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _sobrenome.dispose();
    _altura.dispose();
    _peso.dispose();
    _alergias.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = RegistrationData()
      ..nome = _nome.text.trim()
      ..sobrenome = _sobrenome.text.trim()
      ..altura = int.parse(_altura.text.trim())
      ..peso = int.parse(_peso.text.trim())
      ..alergias = _alergias.text.trim()
      ..sexo = _sexoSelecionado; // ✅ vai para utilizador.sexo

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Dieta(data: data)),
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
                            controller: _nome,
                            decoration: const InputDecoration(labelText: 'Nome'),
                            validator: (n) =>
                                (n == null || n.trim().isEmpty) ? 'Campo obrigatório' : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _sobrenome,
                            decoration: const InputDecoration(labelText: 'Sobrenome'),
                            validator: (n) =>
                                (n == null || n.trim().isEmpty) ? 'Campo obrigatório' : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _altura,
                            decoration: const InputDecoration(labelText: 'Altura em cm'),
                            keyboardType: TextInputType.number,
                            validator: (a) {
                              if (a == null || a.trim().isEmpty) return 'Campo obrigatório';
                              final re = RegExp(r'^\d{3}$');
                              return re.hasMatch(a.trim()) ? null : 'Altura inválida';
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _peso,
                            decoration: const InputDecoration(labelText: 'Peso'),
                            keyboardType: TextInputType.number,
                            validator: (p) {
                              if (p == null || p.trim().isEmpty) return 'Campo obrigatório';
                              final re = RegExp(r'^\d{2,3}$');
                              return re.hasMatch(p.trim()) ? null : 'Peso inválido';
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _alergias,
                            decoration: const InputDecoration(
                              labelText: 'Tem alergias? Se sim, quais?',
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ✅ COMBOBOX SEXO (vai buscar ao enum via RPC)
                          DropdownButtonFormField<String>(
                            value: _sexoSelecionado,
                            decoration: const InputDecoration(labelText: 'Sexo'),
                            items: _sexos
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s),
                                    ))
                                .toList(),
                            onChanged: _aCarregarSexos
                                ? null
                                : (v) => setState(() => _sexoSelecionado = v),
                            validator: (v) {
                              if (_aCarregarSexos) return 'A carregar opções...';
                              if (v == null || v.isEmpty) return 'Selecione uma opção';
                              return null;
                            },
                          ),

                          if (_aCarregarSexos) ...[
                            const SizedBox(height: 8),
                            const LinearProgressIndicator(),
                          ],

                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const MainApp()),
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
