import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/produto.dart';
import '../../../core/formatters/money_formatter.dart';
import 'comparacao_notifier.dart';

class ComparacaoView extends ConsumerWidget {
  final Produto produto;
  const ComparacaoView({super.key, required this.produto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(comparacaoNotifierProvider(produto.id));
  const formatter = MoneyFormatter();

    return Scaffold(
      appBar: AppBar(title: Text('Comparação — ${produto.nome}')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.comparacoes.isEmpty
              ? const Center(child: Text('Nenhum registro encontrado para comparar.'))
              : Column(
                  children: [
                    if (state.comparacoes.length == 1)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Apenas um mercado registrado. Registre em outros mercados para comparar.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.comparacoes.length,
                        itemBuilder: (context, index) {
                          final c = state.comparacoes[index];
                          return ListTile(
                            leading: c.eMenorPreco
                                ? const Icon(Icons.emoji_events, color: Colors.amber)
                                : const Icon(Icons.store),
                            title: Text(c.mercado.nome),
                            subtitle: Text(
                              'Último registro: ${c.dataUltimoRegistro.day}/${c.dataUltimoRegistro.month}/${c.dataUltimoRegistro.year}',
                            ),
                            trailing: Text(
                              formatter.format(c.ultimoPrecoCentavos),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: c.eMenorPreco ? Colors.green : null,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
