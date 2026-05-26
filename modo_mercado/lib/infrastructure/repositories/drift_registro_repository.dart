import '../../core/domain/errors/app_error.dart';
import '../../core/domain/models/registro_de_preco.dart';
import '../../core/protocols/registro_repository.dart';
import '../database/daos/registro_dao.dart';

class DriftRegistroRepository implements RegistroRepository {
  final RegistroDao _dao;

  DriftRegistroRepository(this._dao);

  @override
  Future<List<RegistroDePreco>> listarPorProduto(String produtoId) async {
    try {
      final rows = await _dao.listarPorProduto(produtoId);
      return rows.map(_dao.toDomain).toList();
    } catch (e) {
      throw FalhaAoLerError('registro', e);
    }
  }

  @override
  Future<List<RegistroDePreco>> listarPorMercado(String mercadoId) async {
    try {
      final rows = await _dao.listarPorMercado(mercadoId);
      return rows.map(_dao.toDomain).toList();
    } catch (e) {
      throw FalhaAoLerError('registro', e);
    }
  }

  @override
  Future<List<RegistroDePreco>> listarPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final rows = await _dao.listarPorPeriodo(inicio, fim);
      return rows.map(_dao.toDomain).toList();
    } catch (e) {
      throw FalhaAoLerError('registro', e);
    }
  }

  @override
  Future<void> salvar(RegistroDePreco registro) async {
    try {
      await _dao.inserir(_dao.toCompanion(registro));
    } catch (e) {
      throw FalhaAoSalvarError('registro', e);
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      await _dao.deletar(id);
    } catch (e) {
      throw FalhaAoExcluirError('registro', e);
    }
  }

  @override
  Future<RegistroDePreco?> ultimoPreco(
    String produtoId,
    String mercadoId,
  ) async {
    try {
      final row = await _dao.ultimoPreco(produtoId, mercadoId);
      return row == null ? null : _dao.toDomain(row);
    } catch (e) {
      throw FalhaAoLerError('registro', e);
    }
  }
}
