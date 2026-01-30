import 'package:flutter/material.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/steps_repository.dart';

class StepsHistory extends StatefulWidget {
  final int idutilizador;
  const StepsHistory({super.key, required this.idutilizador});

  @override
  State<StepsHistory> createState() => _StepsHistoryState();
}

/* =======================
   MODEL
======================= */
class StepsHistoryModel {
  bool loading;
  String? error;
  List<Map<String, dynamic>> rows;

  StepsHistoryModel({this.loading = true, this.error, this.rows = const []});
}

/* =======================
   CONTROLLER
======================= */
class StepsHistoryController {
  final StepsRepository repo;

  StepsHistoryController({required this.repo});

  Future<List<Map<String, dynamic>>> carregar(int idutilizador) {
    return repo.fetchSteps(idutilizador);
  }

  String formatarData(dynamic raw) {
    if (raw == null) return "-";

    final parsed = DateTime.tryParse(raw.toString());
    if (parsed == null) return "-";

    const dias = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    String dois(int n) => n.toString().padLeft(2, '0');

    final diaSemana = dias[parsed.weekday % 7];
    final data = "${dois(parsed.day)}/${dois(parsed.month)}/${parsed.year}";

    return "$diaSemana, $data";
  }
}

/* =======================
   UI
======================= */
class _StepsHistoryState extends State<StepsHistory> {
  late final StepsHistoryController controller;
  final StepsHistoryModel model = StepsHistoryModel();

  @override
  void initState() {
    super.initState();
    controller = StepsHistoryController(repo: getIt<StepsRepository>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      model.loading = true;
      model.error = null;
    });

    try {
      final rows = await controller.carregar(widget.idutilizador);
      if (!mounted) return;

      setState(() {
        model.rows = rows;
        model.loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        model.error =
            "Não foi possível carregar o histórico.\nTenta novamente.";
        model.loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Histórico de passos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
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
                padding: const EdgeInsets.all(16),
                child: _buildBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (model.loading) {
      return const _LoadingCard();
    }

    if (model.error != null) {
      return _ErrorCard(mensagem: model.error!, onRetry: _load);
    }

    if (model.rows.isEmpty) {
      return const _EmptyCard();
    }

    return _HistoryList(
      rows: model.rows,
      formatarData: controller.formatarData,
    );
  }
}

/* =======================
   COMPONENTES
======================= */
class _HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  final String Function(dynamic raw) formatarData;

  const _HistoryList({required this.rows, required this.formatarData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: rows.length,
        separatorBuilder: (_, __) => const Divider(height: 10),
        itemBuilder: (context, index) {
          final row = rows[index];
          final passos = row['passos'] ?? 0;
          final data = formatarData(row['created_at']);

          return ListTile(
            tileColor: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.directions_walk,
              color: Color(0xFF1565C0),
            ),
            title: Text(
              '$passos passos',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D47A1),
              ),
            ),
            subtitle: Text(
              data,
              style: const TextStyle(color: Color(0xFF0D47A1)),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 14),
            Text(
              'A carregar histórico...',
              style: TextStyle(color: Color(0xFF0D47A1)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Text(
            'Nenhum registo.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),
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
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 36, color: Color(0xFF0D47A1)),
            const SizedBox(height: 10),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF0D47A1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
