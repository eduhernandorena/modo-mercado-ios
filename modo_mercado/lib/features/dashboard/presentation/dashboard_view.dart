import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/formatters/money_formatter.dart';
import 'dashboard_notifier.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    const formatter = MoneyFormatter();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.carregar,
          ),
        ],
      ),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (data) {
          if (!data.temDados) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum registro no mês atual.\nRegistre preços para ver o resumo financeiro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: notifier.carregar,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Total do mês
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total do mês',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          formatter.format(data.totalMesCentavos),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Economia estimada
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.savings, color: Colors.green),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Economia estimada'),
                            Text(
                              formatter.format(data.economiaEstimadaCentavos),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Top categorias
                if (data.topCategorias.isNotEmpty) ...[
                  const Text('Top Categorias',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...data.topCategorias.map((c) => ListTile(
                        title: Text(c.categoria),
                        trailing: Text(formatter.format(c.totalGastoCentavos)),
                      )),
                  const SizedBox(height: 16),
                ],

                // Produtos com maior aumento
                if (data.produtosComMaiorAumento.isNotEmpty) ...[
                  const Text('Maiores Aumentos',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...data.produtosComMaiorAumento.map((p) => ListTile(
                        title: Text(p.produto.nome),
                        trailing: Text(
                          '+${p.percentualAumento.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
