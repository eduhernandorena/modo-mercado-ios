import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/formatters/money_formatter.dart';
import 'lista_notifier.dart';
import 'lista_detalhe_view.dart';

class ListasView extends ConsumerWidget {
  const ListasView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listaNotifierProvider);
    final notifier = ref.read(listaNotifierProvider.notifier);
    const formatter = MoneyFormatter();

    return Scaffold(
      appBar: AppBar(title: const Text('Listas de Compras')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.listas.isEmpty
              ? const Center(child: Text('Nenhuma lista criada.'))
              : ListView.builder(
                  itemCount: state.listas.length,
                  itemBuilder: (context, index) {
                    final lista = state.listas[index];
                    return ListTile(
                      title: Text(lista.nome),
                      subtitle: Text(
                          '${lista.itens.length} itens · ${formatter.format(lista.totalEstimadoCentavos)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Excluir lista'),
                                  content: Text('Excluir "${lista.nome}"?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancelar')),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        child: const Text('Excluir')),
                                  ],
                                ),
                              );
                              if (ok == true) notifier.excluir(lista.id);
                            },
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ListaDetalheView(lista: lista)),
                      ).then((_) => notifier.carregar()),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = TextEditingController();
          final nome = await showDialog<String>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Nova Lista'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Nome da lista'),
                autofocus: true,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar')),
                TextButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: const Text('Criar')),
              ],
            ),
          );
          if (nome != null && nome.trim().isNotEmpty) {
            notifier.criar(nome.trim());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
