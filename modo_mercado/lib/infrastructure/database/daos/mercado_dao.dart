import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/mercados_table.dart';
import '../../../core/domain/models/mercado.dart' as domain;

part 'mercado_dao.g.dart';

@DriftAccessor(tables: [Mercados])
class MercadoDao extends DatabaseAccessor<AppDatabase>
    with _$MercadoDaoMixin {
  MercadoDao(super.db);

  // ---------------------------------------------------------------------------
  // Conversões
  // ---------------------------------------------------------------------------

  domain.Mercado toDomain(Mercado row) => domain.Mercado(
        id: row.id,
        nome: row.nome,
        criadoEm: row.criadoEm,
      );

  MercadosCompanion toCompanion(domain.Mercado m) => MercadosCompanion(
        id: Value(m.id),
        nome: Value(m.nome),
        criadoEm: Value(m.criadoEm),
      );

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  Future<List<Mercado>> listarTodos() => select(mercados).get();

  Future<Mercado?> buscarPorId(String id) =>
      (select(mercados)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> inserir(MercadosCompanion companion) =>
      into(mercados).insert(companion);

  Future<void> deletar(String id) =>
      (delete(mercados)..where((t) => t.id.equals(id))).go();
}
