import '../../core/domain/errors/app_error.dart';
import '../../core/domain/models/lista_de_compras.dart';
import '../../core/protocols/lista_repository.dart';
import '../database/daos/lista_dao.dart';

class DriftListaRepository implements ListaRepository {
  final ListaDao _dao;

  DriftListaRepository(this._dao);

  @override
  Future<List<ListaDeCompras>> listar() async {
    try {
      final listaRows = await _dao.listarTodasListas();
      final result = <ListaDeCompras>[];
      for (final listaRow in listaRows) {
        final itemRows = await _dao.listarItensDaLista(listaRow.id);
        final itens = itemRows.map(_dao.itemToDomain).toList();
        result.add(ListaDeCompras(
          id: listaRow.id,
          nome: listaRow.nome,
          itens: itens,
          criadoEm: listaRow.criadoEm,
          atualizadoEm: listaRow.atualizadoEm,
        ));
      }
      return result;
    } catch (e) {
      throw FalhaAoLerError('lista', e);
    }
  }

  @override
  Future<void> salvar(ListaDeCompras lista) async {
    try {
      await _dao.inserirLista(_dao.listaToCompanion(lista));
      for (final item in lista.itens) {
        await _dao.inserirItem(_dao.itemToCompanion(item, lista.id));
      }
    } catch (e) {
      throw FalhaAoSalvarError('lista', e);
    }
  }

  @override
  Future<void> atualizar(ListaDeCompras lista) async {
    try {
      await _dao.atualizarLista(_dao.listaToCompanion(lista));
    } catch (e) {
      throw FalhaAoSalvarError('lista', e);
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      await _dao.deletarLista(id);
    } catch (e) {
      throw FalhaAoExcluirError('lista', e);
    }
  }
}
