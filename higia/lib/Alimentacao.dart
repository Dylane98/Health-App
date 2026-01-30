import 'package:flutter/material.dart';
import 'package:higia/menu.dart';

class Alimentacao extends StatefulWidget {
  final int idutilizador;
  const Alimentacao({super.key, required this.idutilizador});

  @override
  State<Alimentacao> createState() => _AlimentacaoState();
}

class _AlimentacaoState extends State<Alimentacao> {
  int coposAgua = 0;

  final List<Map<String, String>> refeicoes = [
    {
      "titulo": "Pequeno-almoço",
      "sub": "Ex.: iogurte + aveia + fruta",
      "icone": "🍓",
    },
    {
      "titulo": "Almoço",
      "sub": "Ex.: frango/atum + arroz + salada",
      "icone": "🍽️",
    },
    {
      "titulo": "Lanche",
      "sub": "Ex.: pão integral + queijo + fruta",
      "icone": "🥪",
    },
    {"titulo": "Jantar", "sub": "Ex.: sopa + omelete + legumes", "icone": "🥣"},
  ];

  final List<String> registoHoje = [];
  final TextEditingController controller = TextEditingController();

  void adicionarAoRegisto() {
    final texto = controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      registoHoje.insert(0, texto);
      controller.clear();
    });
  }

  void removerDoRegisto(int index) {
    setState(() {
      registoHoje.removeAt(index);
    });
  }

  @override
  void dispose() {
    controller.dispose();
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
                      child: Image.asset('images/alimentacao.png', height: 70),
                    ),
                    const SizedBox(height: 20),

                    // Água (offline)
                    _CardSection(
                      title: "Hidratação",
                      child: Column(
                        children: [
                          Text(
                            "Copos de água hoje: $coposAgua",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => setState(() => coposAgua++),
                                icon: const Icon(Icons.water_drop),
                                label: const Text("Adicionar"),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: coposAgua == 0
                                    ? null
                                    : () => setState(() => coposAgua--),
                                icon: const Icon(Icons.remove),
                                label: const Text("Remover"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Plano do dia (sugestões)
                    _CardSection(
                      title: "Plano do dia (sugestões)",
                      child: Column(
                        children: refeicoes.map((r) {
                          return _MealTile(
                            emoji: r["icone"] ?? "🍽️",
                            title: r["titulo"] ?? "",
                            subtitle: r["sub"] ?? "",
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Registo rápido (offline)
                    _CardSection(
                      title: "Registo rápido (sem BD)",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Ex.: 1 banana, 1 iogurte, sopa...",
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.85),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSubmitted: (_) => adicionarAoRegisto(),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: adicionarAoRegisto,
                            child: const Text("Adicionar ao registo"),
                          ),
                          const SizedBox(height: 12),

                          if (registoHoje.isEmpty)
                            const Text(
                              "Ainda não registaste nada hoje.",
                              textAlign: TextAlign.center,
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: registoHoje.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 10),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  tileColor: Colors.white.withOpacity(0.75),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  leading: const Icon(
                                    Icons.check_circle_outline,
                                  ),
                                  title: Text(registoHoje[index]),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => removerDoRegisto(index),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Dicas rápidas (offline)
                    _CardSection(
                      title: "Dicas rápidas",
                      child: Column(
                        children: const [
                          _TipLine(text: "✅ Metade do prato: legumes/salada"),
                          _TipLine(
                            text:
                                "✅ Proteína: frango, ovos, peixe ou leguminosas",
                          ),
                          _TipLine(
                            text:
                                "✅ Hidratos: arroz, massa, batata (porção moderada)",
                          ),
                          _TipLine(
                            text: "✅ Evita bebidas açucaradas no dia-a-dia",
                          ),
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

class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _MealTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Text(emoji, style: const TextStyle(fontSize: 26)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
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
          const Icon(Icons.lightbulb_outline),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
