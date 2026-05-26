import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'produtos_notifier.dart';
import 'produto_form_view.dart';

class ProdutosListView extends ConsumerWidget {
  const ProdutosListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(produtosNotifierProvider);
    final notifier = ref.read(produtosNotifierProvider.notifier);

    if (state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
        notifier.limparErro();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              hintText: 'Buscar por nome ou categoria...',
              leading: const Icon(Icons.search),
              onChanged: (termo) => notifier.carregar(termoBusca: termo),
            ),
          ),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.produtos.isEmpty
              ? const Center(child: Text('Nenhum produto cadastrado.'))
              : ListView.builder(
                  itemCount: state.produtos.length,
                  itemBuilder: (context, index) {
                    final produto = state.produtos[index];
                    return ListTile(
                      title: Text(produto.nome),
                      subtitle: Text('${produto.categoria} · ${produto.unidade}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProdutoFormView(produto: produto),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProdutoFormView()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
