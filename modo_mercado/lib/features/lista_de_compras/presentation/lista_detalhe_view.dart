import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/lista_de_compras.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../../infrastructure/providers.dart';
import 'lista_notifier.dart';

class ListaDetalheView extends ConsumerWidget {
  final ListaDeCompras lista;
  const ListaDetalheView({super.key, required this.lista});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listaNotifierProvider);
    final notifier = ref.read(listaNotifierProvider.notifier);
    const formatter = MoneyFormatter();

    // Pegar a versão mais recente da lista do estado
    final listaAtual = state.listas.where((l) => l.id == lista.id).firstOrNull ?? lista;

    // Agrupar itens por categoria (usando produtoId como chave temporária)
    final itensPorCategoria = <String, List<dynamic>>{};
    for (final item in listaAtual.itens) {
      itensPorCategoria.putIfAbsent('Produtos', () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(listaAtual.nome),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total estimado:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  formatter.format(listaAtual.totalEstimadoCentavos),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: listaAtual.itens.isEmpty
          ? const Center(child: Text('Nenhum item na lista.'))
          : ListView.builder(
              itemCount: listaAtual.itens.length,
              itemBuilder: (context, index) {
                final item = listaAtual.itens[index];
                return ListTile(
                  leading: Checkbox(
                    value: item.concluido,
                    onChanged: (v) =>
                        notifier.marcarConcluido(listaAtual, item.id, v ?? false),
                  ),
                  title: Text(
                    item.produtoId,
                    style: item.concluido
                        ? const TextStyle(decoration: TextDecoration.lineThrough)
                        : null,
                  ),
                  subtitle: item.ultimoPrecoRegistradoCentavos != null
                      ? Text(
                          '${formatter.format(item.ultimoPrecoRegistradoCentavos!)} × ${item.quantidade.toStringAsFixed(1)} = ${formatter.format(item.subtotalEstimadoCentavos)}')
                      : const Text('Sem preço registrado'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => notifier.removerItem(listaAtual, item.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final produtos = await ref.read(produtoRepositoryProvider).listar();
          if (!context.mounted) return;
          final produto = await showDialog(
            context: context,
            builder: (_) => SimpleDialog(
              title: const Text('Selecionar Produto'),
              children: produtos
                  .map((p) => SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, p),
                        child: Text(p.nome),
                      ))
                  .toList(),
            ),
          );
          if (produto == null) return;
          final ok = await notifier.adicionarItem(listaAtual, produto, 1.0);
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Erro ao adicionar item')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
