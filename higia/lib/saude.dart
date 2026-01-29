// dart
// File: `higia/higia/lib/saude.dart` (changes)
// - Guard against null Supabase client and use safe parsing
import 'package:flutter/material.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/menu.dart';
import 'package:higia/services/user_service.dart';

class Saude extends StatelessWidget {
  final int idutilizador;
  final RegistrationData data;

  Saude({super.key, required this.data, required this.idutilizador});

  UserService get _userService => UserService();

  int _calcularIdade(DateTime? nascimento) {
    if (nascimento == null) return 0;
    final today = DateTime.now();
    int age = today.year - nascimento.year;
    if (today.month < nascimento.month ||
        (today.month == nascimento.month && today.day < nascimento.day)) {
      age--;
    }
    return age;
  }

  Future<RegistrationData?> _fetchRegistrationData() =>
      _userService.fetchUserData(idutilizador);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Menu(idutilizador: idutilizador),
                ),
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
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Image.asset('images/Saude.png', height: 70),
                    const SizedBox(height: 52),
                    // ... (rest unchanged) ...
                    Padding(
                      padding: const EdgeInsets.only(left: 131),
                      child: FutureBuilder<RegistrationData?>(
                        future: _fetchRegistrationData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const SizedBox(
                                width: 60,
                                height: 16,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }

                          final fetched = snapshot.data;
                          final nascimento =
                              fetched?.dataNascimento ?? data.dataNascimento;
                          final idade = _calcularIdade(nascimento);

                          final pesoText = (fetched?.peso ?? data.peso)
                              .toString();
                          final alturaText = (fetched?.altura ?? data.altura)
                              .toString();
                          final nivelText =
                              (fetched?.nivelAtividadeDiaria ??
                                      data.nivelAtividadeDiaria)
                                  .toString();
                          final atividadePreferida =
                              (fetched?.AtividadePreferida ??
                                      data.AtividadePreferida)
                                  .toString();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Idade: $idade anos'),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Peso: $pesoText kg'),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Altura: $alturaText cm'),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Nível de atividade diária: $nivelText',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Atividade preferida: $atividadePreferida',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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
