import '../../../../core/domain/errors/app_error.dart';
import '../../../../core/protocols/produto_repository.dart';

class ExcluirProdutoUseCase {
  final ProdutoRepository repository;
  const ExcluirProdutoUseCase(this.repository);

  Future<void> executar(String produtoId, String nomeProduto) async {
    final possuiRegistros = await repository.possuiRegistros(produtoId);
    if (possuiRegistros) {
      throw AppError.produtoPossuiRegistros(nomeProduto);
    }
    await repository.excluir(produtoId);
  }
}
