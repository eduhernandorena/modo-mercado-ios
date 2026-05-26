import '../domain/models/produto.dart';

abstract class ProdutoRepository {
  Future<List<Produto>> listar();
  Future<List<Produto>> buscar(String termo);
  Future<void> salvar(Produto produto);
  Future<void> atualizar(Produto produto);
  Future<void> excluir(String id);
  Future<bool> possuiRegistros(String produtoId);
}
