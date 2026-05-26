import '../../../../core/domain/models/produto.dart';
import '../../../../core/protocols/produto_repository.dart';

class ListarProdutosUseCase {
  final ProdutoRepository repository;
  const ListarProdutosUseCase(this.repository);

  Future<List<Produto>> executar({String? termoBusca}) async {
    final produtos = termoBusca != null && termoBusca.trim().isNotEmpty
        ? await repository.buscar(termoBusca.trim())
        : await repository.listar();

    // Ordenação alfabética case-insensitive
    final ordenados = List<Produto>.from(produtos)
      ..sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    return ordenados;
  }
}
