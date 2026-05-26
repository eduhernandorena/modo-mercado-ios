import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/listas_table.dart';
import '../tables/itens_table.dart';
import '../../../core/domain/models/lista_de_compras.dart' as domain;
import '../../../core/domain/models/item_de_lista.dart' as domain_item;

part 'lista_dao.g.dart';

@DriftAccessor(tables: [ListasDeCompras, ItensDeLista])
class ListaDao extends DatabaseAccessor<AppDatabase> with _$ListaDaoMixin {
  ListaDao(super.db);

  // ---------------------------------------------------------------------------
  // Conversões
  // ---------------------------------------------------------------------------

  domain_item.ItemDeLista itemToDomain(ItensDeListaData row) =>
      domain_item.ItemDeLista(
        id: row.id,
        produtoId: row.produtoId,
        quantidade: row.quantidade,
        concluido: row.concluido,
        ultimoPrecoRegistradoCentavos: row.ultimoPrecoRegistradoCentavos,
      );

  ItensDeListaCompanion itemToCompanion(
    domain_item.ItemDeLista item,
    String listaId,
  ) =>
      ItensDeListaCompanion(
        id: Value(item.id),
        listaId: Value(listaId),
        produtoId: Value(item.produtoId),
        quantidade: Value(item.quantidade),
        concluido: Value(item.concluido),
        ultimoPrecoRegistradoCentavos:
            Value(item.ultimoPrecoRegistradoCentavos),
      );

  ListasDeComprasCompanion listaToCompanion(domain.ListaDeCompras l) =>
      ListasDeComprasCompanion(
        id: Value(l.id),
        nome: Value(l.nome),
        criadoEm: Value(l.criadoEm),
        atualizadoEm: Value(l.atualizadoEm),
      );

  // ---------------------------------------------------------------------------
  // Queries — Listas
  // ---------------------------------------------------------------------------

  Future<List<ListasDeCompra>> listarTodasListas() =>
      select(listasDeCompras).get();

  Future<void> inserirLista(ListasDeComprasCompanion companion) =>
      into(listasDeCompras).insert(companion);

  Future<void> atualizarLista(ListasDeComprasCompanion companion) =>
      (update(listasDeCompras)
            ..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deletarLista(String id) =>
      (delete(listasDeCompras)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Queries — Itens
  // ---------------------------------------------------------------------------

  Future<List<ItensDeListaData>> listarItensDaLista(String listaId) =>
      (select(itensDeLista)..where((t) => t.listaId.equals(listaId))).get();

  Future<void> inserirItem(ItensDeListaCompanion companion) =>
      into(itensDeLista).insert(companion);

  Future<void> deletarItem(String id) =>
      (delete(itensDeLista)..where((t) => t.id.equals(id))).go();
}
