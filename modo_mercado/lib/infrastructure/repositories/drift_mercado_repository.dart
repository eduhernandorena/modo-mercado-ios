import '../../core/domain/errors/app_error.dart';
import '../../core/domain/models/mercado.dart';
import '../../core/protocols/mercado_repository.dart';
import '../database/daos/mercado_dao.dart';

class DriftMercadoRepository implements MercadoRepository {
  final MercadoDao _dao;

  DriftMercadoRepository(this._dao);

  @override
  Future<List<Mercado>> listar() async {
    try {
      final rows = await _dao.listarTodos();
      return rows.map(_dao.toDomain).toList();
    } catch (e) {
      throw FalhaAoLerError('mercado', e);
    }
  }

  @override
  Future<void> salvar(Mercado mercado) async {
    try {
      await _dao.inserir(_dao.toCompanion(mercado));
    } catch (e) {
      throw FalhaAoSalvarError('mercado', e);
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      await _dao.deletar(id);
    } catch (e) {
      throw FalhaAoExcluirError('mercado', e);
    }
  }
}
