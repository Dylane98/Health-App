import 'dart:async';
import 'package:flutter/material.dart';
import 'package:higia/menu.dart';

class Relaxamento extends StatefulWidget {
  final int idutilizador;
  const Relaxamento({super.key, required this.idutilizador});

  @override
  State<Relaxamento> createState() => _RelaxamentoState();
}

class _RelaxamentoState extends State<Relaxamento> {
  Timer? timer;
  Duration restante = Duration.zero;
  bool aDecorrer = false;
  String tituloSessao = "Respiração 4-4-4";

  // Registo simples (só em memória)
  final List<String> registo = [];

  final List<_SessaoRelax> sessoes = const [
    _SessaoRelax(
      titulo: "Respiração 4-4-4",
      descricao: "Inspira 4s • segura 4s • expira 4s (repetir)",
      duracao: Duration(minutes: 2),
      emoji: "🌬️",
    ),
    _SessaoRelax(
      titulo: "Box Breathing",
      descricao: "Inspira 4s • segura 4s • expira 4s • segura 4s",
      duracao: Duration(minutes: 3),
      emoji: "🧊",
    ),
    _SessaoRelax(
      titulo: "Body Scan",
      descricao: "Relaxar o corpo dos pés à cabeça",
      duracao: Duration(minutes: 5),
      emoji: "🧘",
    ),
    _SessaoRelax(
      titulo: "Pausa 1 minuto",
      descricao: "Fecha os olhos e solta a tensão dos ombros",
      duracao: Duration(minutes: 1),
      emoji: "⏳",
    ),
  ];

  void iniciar(Duration d) {
    timer?.cancel();
    setState(() {
      restante = d;
      aDecorrer = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (restante.inSeconds <= 0) {
        t.cancel();
        setState(() => aDecorrer = false);
        _terminou();
      } else {
        setState(() => restante -= const Duration(seconds: 1));
      }
    });
  }

  void parar() {
    timer?.cancel();
    setState(() => aDecorrer = false);
  }

  void _terminou() {
    final agora = TimeOfDay.now();
    final hh = agora.hour.toString().padLeft(2, '0');
    final mm = agora.minute.toString().padLeft(2, '0');

    setState(() {
      registo.insert(0, "✅ $tituloSessao concluída às $hh:$mm");
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Boa! ✅"),
        content: Text("Sessão concluída: $tituloSessao"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String formatar(Duration d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return "${dois(d.inMinutes)}:${dois(d.inSeconds % 60)}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Menu(idutilizador: widget.idutilizador),
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
              width: 520,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset('images/meditacao.png', height: 70),
                    ),
                    const SizedBox(height: 20),

                    // Temporizador / sessão atual
                    _CardSection(
                      title: "Sessão atual",
                      child: Column(
                        children: [
                          Text(
                            tituloSessao,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D47A1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            formatar(restante),
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (!aDecorrer)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final s = sessoes.firstWhere(
                                      (x) => x.titulo == tituloSessao,
                                      orElse: () => sessoes.first,
                                    );
                                    iniciar(s.duracao);
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text("Iniciar"),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      restante = Duration.zero;
                                    });
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Reset"),
                                ),
                              ],
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: parar,
                              icon: const Icon(Icons.stop),
                              label: const Text("Parar"),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Lista de sessões
                    _CardSection(
                      title: "Escolher exercício",
                      child: Column(
                        children: sessoes.map((s) {
                          return ListTile(
                            leading: Text(
                              s.emoji,
                              style: const TextStyle(fontSize: 26),
                            ),
                            title: Text(
                              s.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            subtitle: Text(
                              "${s.descricao}\nDuração: ${s.duracao.inMinutes} min",
                              style: const TextStyle(color: Color(0xFF0D47A1)),
                            ),
                            isThreeLine: true,
                            onTap: () {
                              if (aDecorrer) return;
                              setState(() {
                                tituloSessao = s.titulo;
                                restante = s.duracao;
                              });
                            },
                            trailing: aDecorrer
                                ? const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF1565C0),
                                  )
                                : const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF1565C0),
                                  ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Dicas rápidas
                    _CardSection(
                      title: "Dicas rápidas",
                      child: const Column(
                        children: [
                          _TipLine(
                            text: "✅ Ombros baixos e mandíbula relaxada",
                          ),
                          _TipLine(
                            text: "✅ Inspira pelo nariz, expira devagar",
                          ),
                          _TipLine(
                            text: "✅ Se a mente fugir, volta à respiração",
                          ),
                          _TipLine(text: "✅ 2–5 minutos já fazem diferença"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
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

class _SessaoRelax {
  final String titulo;
  final String descricao;
  final Duration duracao;
  final String emoji;

  const _SessaoRelax({
    required this.titulo,
    required this.descricao,
    required this.duracao,
    required this.emoji,
  });
}

// =================== CARD AZUL (IGUAL AO MENU) ===================

class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD), // 🔵 azul claro
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _TipLine extends StatelessWidget {
  final String text;
  const _TipLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.self_improvement, color: Color(0xFF1565C0)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Color(0xFF0D47A1))),
          ),
        ],
      ),
    );
  }
}
