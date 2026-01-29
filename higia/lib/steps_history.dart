import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stepsRepo = getIt<StepsRepository>();
    final rows = await stepsRepo.fetchSteps(widget.idutilizador);
    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de passos')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _rows.isEmpty
                ? const Center(child: Text('Nenhum registo'))
                : ListView.separated(
                    itemCount: _rows.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, idx) {
                      final row = _rows[idx];
                      final date = row['created_at'] ?? '';
                      final steps = row['passos'] ?? 0;
                      return ListTile(
                        title: Text('$steps passos'),
                        subtitle: Text(date.toString()),
                      );
                    },
                  ),
      ),
    );
  }
}
