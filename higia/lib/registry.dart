import 'package:flutter/material.dart';
import 'package:higia/dieta.dart';
import 'package:higia/main.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/services/lookup_service.dart';

final _lookupService = LookupService();

class RegisterPage extends StatefulWidget {
  final RegistrationData data;
  const RegisterPage({super.key, required this.data});

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
  final _dataNascimento = TextEditingController();

  List<String> _sexos = [];
  String? _sexoSelecionado;
  bool _aCarregarSexos = true;

  @override
  void initState() {
    super.initState();
    _carregarSexos();

    final d = widget.data;
    if (d.nome != null) _nome.text = d.nome!;
    if (d.sobrenome != null) _sobrenome.text = d.sobrenome!;
    if (d.altura != null) _altura.text = d.altura.toString();
    if (d.peso != null) _peso.text = d.peso.toString();
    if (d.alergias != null) _alergias.text = d.alergias!;
    if (d.dataNascimento != null) {
      _dataNascimento.text = d.dataNascimento!
          .toIso8601String()
          .split('T')
          .first;
    }
    if (d.sexo != null) _sexoSelecionado = d.sexo;
  }

  Future<void> _carregarSexos() async {
    try {
      final lista = await _lookupService.fetchSexos();
      if (!mounted) return;
      setState(() {
        _sexos = lista;
        _aCarregarSexos = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _aCarregarSexos = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar sexos: $e')));
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _sobrenome.dispose();
    _altura.dispose();
    _peso.dispose();
    _alergias.dispose();
    _dataNascimento.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final nome = _nome.text.trim();
    final sobrenome = _sobrenome.text.trim();
    final alturaText = _altura.text.trim();
    final pesoText = _peso.text.trim();
    final alergias = _alergias.text.trim();
    final dataNascimentoText = _dataNascimento.text.trim();

    final altura = int.tryParse(alturaText);
    final peso = double.tryParse(pesoText);
    final dataNascimento = dataNascimentoText.isNotEmpty
        ? DateTime.tryParse(dataNascimentoText)
        : null;

    widget.data.nome = nome.isNotEmpty ? nome : null;
    widget.data.sobrenome = sobrenome.isNotEmpty ? sobrenome : null;
    widget.data.altura = altura;
    widget.data.peso = peso;
    widget.data.alergias = alergias.isNotEmpty ? alergias : null;
    widget.data.dataNascimento = dataNascimento;
    widget.data.sexo = _sexoSelecionado;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Dieta(data: widget.data)),
    );
  }

  InputDecoration _dec(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
                                  Icons.assignment_ind,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Registo",
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
                              "Preenche os teus dados para personalizar a experiência.",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

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
                                controller: _nome,
                                decoration: _dec("Nome", Icons.person_outline),
                                validator: (n) =>
                                    (n == null || n.trim().isEmpty)
                                    ? 'Campo obrigatório'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _sobrenome,
                                decoration: _dec("Sobrenome", Icons.person),
                                validator: (n) =>
                                    (n == null || n.trim().isEmpty)
                                    ? 'Campo obrigatório'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _altura,
                                decoration: _dec("Altura (cm)", Icons.height),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _dataNascimento,
                                decoration: _dec(
                                  "Data de nascimento",
                                  Icons.cake_outlined,
                                  hint: "YYYY-MM-DD",
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTap: () async {
                                  DateTime initialDate = DateTime.now();
                                  final existing = _dataNascimento.text.trim();
                                  if (existing.isNotEmpty) {
                                    final parsed = DateTime.tryParse(existing);
                                    if (parsed != null) initialDate = parsed;
                                  }

                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (picked != null) {
                                    final formatted = picked
                                        .toIso8601String()
                                        .split('T')
                                        .first;
                                    setState(
                                      () => _dataNascimento.text = formatted,
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _peso,
                                decoration: _dec(
                                  "Peso (kg)",
                                  Icons.monitor_weight_outlined,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _alergias,
                                decoration: _dec(
                                  "Alergias",
                                  Icons.warning_amber_rounded,
                                  hint: "Se sim, quais?",
                                ),
                              ),

                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                initialValue: _sexoSelecionado,
                                decoration: _dec("Sexo", Icons.wc),
                                items: _sexos
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _aCarregarSexos
                                    ? null
                                    : (v) =>
                                          setState(() => _sexoSelecionado = v),
                                validator: (v) {
                                  if (_aCarregarSexos)
                                    return 'A carregar opções...';
                                  if (v == null || v.isEmpty)
                                    return 'Selecione uma opção';
                                  return null;
                                },
                              ),

                              if (_aCarregarSexos) ...[
                                const SizedBox(height: 10),
                                const LinearProgressIndicator(),
                              ],

                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF1565C0),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MainApp(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.close),
                                    label: const Text('Cancelar'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _submit,
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
                                    icon: const Icon(Icons.arrow_forward),
                                    label: const Text('Seguinte'),
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
