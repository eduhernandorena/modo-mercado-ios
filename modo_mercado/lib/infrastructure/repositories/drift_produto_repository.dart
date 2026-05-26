import '../../core/domain/errors/app_error.dart';
import '../../core/domain/models/produto.dart';
import '../../core/protocols/produto_repository.dart';
import '../database/daos/produto_dao.dart';

class DriftProdutoRepository implements ProdutoRepository {
  final ProdutoDao _dao;

  DriftProdutoRepository(this._dao);

  @override
  Future<List<Produto>> listar() async {
    try {
      final rows = await _dao.listarTodos();
      return rows.map(_dao.toDomain).toList();
    } catch (e) {
      throw FalhaAoLerError('produto', e);
    }
  }

  @override
  Future<List<Produto>> buscar(String termo) async {
    try {
      final rows = await _dao.buscar(termo);
      return rows.map(_dao.toDomain).toList();
    } catch (e) {
      throw FalhaAoLerError('produto', e);
    }
  }

  @override
  Future<void> salvar(Produto produto) async {
    try {
      await _dao.inserir(_dao.toCompanion(produto));
    } catch (e) {
      throw FalhaAoSalvarError('produto', e);
    }
  }

  @override
  Future<void> atualizar(Produto produto) async {
    try {
      await _dao.atualizar(_dao.toCompanion(produto));
    } catch (e) {
      throw FalhaAoSalvarError('produto', e);
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      await _dao.deletar(id);
    } catch (e) {
      throw FalhaAoExcluirError('produto', e);
    }
  }

  @override
  Future<bool> possuiRegistros(String produtoId) async {
    try {
      return await _dao.possuiRegistros(produtoId);
    } catch (e) {
      throw FalhaAoLerError('produto', e);
    }
  }
}
