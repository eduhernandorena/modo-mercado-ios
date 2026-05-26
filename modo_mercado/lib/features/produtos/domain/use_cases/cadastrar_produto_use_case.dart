import 'package:uuid/uuid.dart';
import '../../../../core/domain/errors/app_error.dart';
import '../../../../core/domain/models/produto.dart';
import '../../../../core/protocols/produto_repository.dart';

class CadastrarProdutoUseCase {
  final ProdutoRepository repository;
  const CadastrarProdutoUseCase(this.repository);

  Future<Produto> executar({
    required String nome,
    required String categoria,
    required String unidade,
    String? marca,
    double? quantidade,
    String? observacao,
  }) async {
    if (nome.trim().isEmpty) throw const AppError.campoObrigatorioAusente('nome');
    if (categoria.trim().isEmpty) throw const AppError.campoObrigatorioAusente('categoria');
    if (unidade.trim().isEmpty) throw const AppError.campoObrigatorioAusente('unidade');

    final agora = DateTime.now();
    final produto = Produto(
      id: const Uuid().v4(),
      nome: nome.trim(),
      categoria: categoria.trim(),
      unidade: unidade.trim(),
      marca: marca?.trim().isEmpty == true ? null : marca?.trim(),
      quantidade: quantidade,
      observacao: observacao?.trim().isEmpty == true ? null : observacao?.trim(),
      criadoEm: agora,
      atualizadoEm: agora,
    );
    await repository.salvar(produto);
    return produto;
  }
}
