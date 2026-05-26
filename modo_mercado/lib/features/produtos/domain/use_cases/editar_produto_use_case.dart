import '../../../../core/domain/errors/app_error.dart';
import '../../../../core/domain/models/produto.dart';
import '../../../../core/protocols/produto_repository.dart';

class EditarProdutoUseCase {
  final ProdutoRepository repository;
  const EditarProdutoUseCase(this.repository);

  Future<Produto> executar(Produto produto) async {
    if (produto.nome.trim().isEmpty) throw const AppError.campoObrigatorioAusente('nome');
    if (produto.categoria.trim().isEmpty) throw const AppError.campoObrigatorioAusente('categoria');
    if (produto.unidade.trim().isEmpty) throw const AppError.campoObrigatorioAusente('unidade');

    final atualizado = produto.copyWith(atualizadoEm: DateTime.now());
    await repository.atualizar(atualizado);
    return atualizado;
  }
}
