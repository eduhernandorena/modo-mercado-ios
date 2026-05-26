import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/produto.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../registros/presentation/registro_form_view.dart';
import '../../comparacao/presentation/comparacao_view.dart';
import 'historico_notifier.dart';
import 'preco_chart_view.dart';

class HistoricoView extends ConsumerWidget {
  final Produto produto;
  const HistoricoView({super.key, required this.produto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historicoNotifierProvider(produto.id));
    final notifier = ref.read(historicoNotifierProvider(produto.id).notifier);
    const formatter = MoneyFormatter();

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Comparar mercados',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ComparacaoView(produto: produto)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo registro',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RegistroFormView(produtoPreSelecionado: produto),
              ),
            ).then((_) => notifier.carregar()),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: notifier.carregar,
              child: CustomScrollView(
                slivers: [
                  // Filtros
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String?>(
                              isExpanded: true,
                              hint: const Text('Todos os mercados'),
                              value: state.filtroMercadoId,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('Todos')),
                                ...state.mercados.map((m) =>
                                    DropdownMenuItem(value: m.id, child: Text(m.nome))),
                              ],
                              onChanged: notifier.filtrarPorMercado,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Métricas
                  if (state.metricas != null && state.metricas!.registros.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _MetricaCard(
                              label: 'Menor',
                              valor: formatter.format(state.metricas!.menorPrecoCentavos ?? 0),
                              cor: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            _MetricaCard(
                              label: 'Média',
                              valor: formatter.format(state.metricas!.mediaPrecoCentavos ?? 0),
                              cor: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            _MetricaCard(
                              label: 'Maior',
                              valor: formatter.format(state.metricas!.maiorPrecoCentavos ?? 0),
                              cor: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Gráfico
                  if (state.metricas != null && state.metricas!.registros.isNotEmpty)
                    SliverToBoxAdapter(
                      child: PrecoChartView(registros: state.metricas!.registros),
                    ),
                  // Lista de registros
                  if (state.metricas == null || state.metricas!.registros.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('Nenhum registro encontrado.')),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final r = state.metricas!.registros[index];
                          final mercado = state.mercados
                              .where((m) => m.id == r.mercadoId)
                              .firstOrNull;
                          return ListTile(
                            title: Text(formatter.format(r.valorCentavos)),
                            subtitle: Text(
                                '${mercado?.nome ?? r.mercadoId} · ${r.data.day}/${r.data.month}/${r.data.year}'),
                          );
                        },
                        childCount: state.metricas!.registros.length,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _MetricaCard extends StatelessWidget {
  final String label;
  final String valor;
  final Color cor;
  const _MetricaCard({required this.label, required this.valor, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(label, style: TextStyle(color: cor, fontWeight: FontWeight.bold)),
              Text(valor, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
