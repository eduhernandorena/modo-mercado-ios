import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/registros_table.dart';
import '../../../core/domain/models/registro_de_preco.dart' as domain;

part 'registro_dao.g.dart';

@DriftAccessor(tables: [RegistrosDePreco])
class RegistroDao extends DatabaseAccessor<AppDatabase>
    with _$RegistroDaoMixin {
  RegistroDao(super.db);

  // ---------------------------------------------------------------------------
  // Conversões
  // ---------------------------------------------------------------------------

  domain.RegistroDePreco toDomain(RegistrosDePrecoData row) =>
      domain.RegistroDePreco(
        id: row.id,
        produtoId: row.produtoId,
        mercadoId: row.mercadoId,
        valorCentavos: row.valorCentavos,
        data: row.data,
        fotoPath: row.fotoPath,
        criadoEm: row.criadoEm,
      );

  RegistrosDePrecoCompanion toCompanion(domain.RegistroDePreco r) =>
      RegistrosDePrecoCompanion(
        id: Value(r.id),
        produtoId: Value(r.produtoId),
        mercadoId: Value(r.mercadoId),
        valorCentavos: Value(r.valorCentavos),
        data: Value(r.data),
        fotoPath: Value(r.fotoPath),
        criadoEm: Value(r.criadoEm),
      );

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  Future<List<RegistrosDePrecoData>> listarPorProduto(String produtoId) =>
      (select(registrosDePreco)
            ..where((t) => t.produtoId.equals(produtoId))
            ..orderBy([(t) => OrderingTerm.desc(t.data)]))
          .get();

  Future<List<RegistrosDePrecoData>> listarPorMercado(String mercadoId) =>
      (select(registrosDePreco)
            ..where((t) => t.mercadoId.equals(mercadoId))
            ..orderBy([(t) => OrderingTerm.desc(t.data)]))
          .get();

  Future<List<RegistrosDePrecoData>> listarPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) =>
      (select(registrosDePreco)
            ..where(
              (t) =>
                  t.data.isBiggerOrEqualValue(inicio) &
                  t.data.isSmallerOrEqualValue(fim),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.data)]))
          .get();

  Future<RegistrosDePrecoData?> ultimoPreco(
    String produtoId,
    String mercadoId,
  ) =>
      (select(registrosDePreco)
            ..where(
              (t) =>
                  t.produtoId.equals(produtoId) &
                  t.mercadoId.equals(mercadoId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.data)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> inserir(RegistrosDePrecoCompanion companion) =>
      into(registrosDePreco).insert(companion);

  Future<void> deletar(String id) =>
      (delete(registrosDePreco)..where((t) => t.id.equals(id))).go();
}
