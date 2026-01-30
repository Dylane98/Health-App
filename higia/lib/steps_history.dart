import 'package:flutter/material.dart';
import 'package:higia/menu.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/steps_repository.dart';

class StepsHistory extends StatefulWidget {
  final int idutilizador;
  const StepsHistory({super.key, required this.idutilizador});

  @override
  State<StepsHistory> createState() => _StepsHistoryState();
}

class _StepsHistoryState extends State<StepsHistory> {
  List<Map<String, dynamic>> _rows = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  String _fmtDatePt(DateTime? d) {
    if (d == null) return "-";
    String dois(int n) => n.toString().padLeft(2, '0');
    return "${dois(d.day)}/${dois(d.month)}/${d.year}  ${dois(d.hour)}:${dois(d.minute)}";
  }

  int _toInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? "") ?? 0;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final stepsRepo = getIt<StepsRepository>();
      final rows = await stepsRepo.fetchSteps(widget.idutilizador);

      // ordenar por data desc (mais recente primeiro)
      rows.sort((a, b) {
        final da =
            _parseDate(a['created_at']) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final db =
            _parseDate(b['created_at']) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return db.compareTo(da);
      });

      if (!mounted) return;
      setState(() {
        _rows = rows;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  int get _totalPassos =>
      _rows.fold<int>(0, (sum, r) => sum + _toInt(r['passos']));
  int get _media => _rows.isEmpty ? 0 : (_totalPassos / _rows.length).round();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Histórico de passos'),
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
        actions: [
          IconButton(
            tooltip: "Atualizar",
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? _ErrorCard(
                        mensagem:
                            "Não foi possível carregar o histórico.\n$_error",
                        onRetry: _load,
                      )
                    : _rows.isEmpty
                    ? const _EmptyCard(texto: "Nenhum registo ainda.")
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView(
                          children: [
                            _CardSection(
                              title: "Resumo",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _StatBox(
                                    label: "Registos",
                                    value: "${_rows.length}",
                                  ),
                                  _StatBox(
                                    label: "Total",
                                    value: "$_totalPassos",
                                  ),
                                  _StatBox(label: "Média", value: "$_media"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _CardSection(
                              title: "Registos",
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _rows.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 12),
                                itemBuilder: (context, idx) {
                                  final row = _rows[idx];
                                  final dt = _parseDate(row['created_at']);
                                  final steps = _toInt(row['passos']);

                                  return ListTile(
                                    tileColor: Colors.white.withOpacity(0.75),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    leading: const Icon(Icons.directions_walk),
                                    title: Text(
                                      "$steps passos",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(_fmtDatePt(dt)),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String texto;
  const _EmptyCard({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(child: Text(texto)),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String mensagem;
  final VoidCallback onRetry;

  const _ErrorCard({required this.mensagem, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 36),
            const SizedBox(height: 10),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Tentar novamente"),
            ),
          ],
        ),
      ),
    );
  }
}
