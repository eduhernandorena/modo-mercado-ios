import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/produtos_table.dart';
import '../tables/registros_table.dart';
import '../../../core/domain/models/produto.dart' as domain;

part 'produto_dao.g.dart';

@DriftAccessor(tables: [Produtos, RegistrosDePreco])
class ProdutoDao extends DatabaseAccessor<AppDatabase>
    with _$ProdutoDaoMixin {
  ProdutoDao(super.db);

  // ---------------------------------------------------------------------------
  // Conversões
  // ---------------------------------------------------------------------------

  domain.Produto toDomain(Produto row) => domain.Produto(
        id: row.id,
        nome: row.nome,
        categoria: row.categoria,
        unidade: row.unidade,
        marca: row.marca,
        quantidade: row.quantidade,
        observacao: row.observacao,
        criadoEm: row.criadoEm,
        atualizadoEm: row.atualizadoEm,
      );

  ProdutosCompanion toCompanion(domain.Produto p) => ProdutosCompanion(
        id: Value(p.id),
        nome: Value(p.nome),
        categoria: Value(p.categoria),
        unidade: Value(p.unidade),
        marca: Value(p.marca),
        quantidade: Value(p.quantidade),
        observacao: Value(p.observacao),
        criadoEm: Value(p.criadoEm),
        atualizadoEm: Value(p.atualizadoEm),
      );

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  Future<List<Produto>> listarTodos() => select(produtos).get();

  Future<List<Produto>> buscar(String termo) {
    final termoLower = termo.toLowerCase();
    return (select(produtos)
          ..where(
            (t) =>
                t.nome.lower().contains(termoLower) |
                t.categoria.lower().contains(termoLower),
          ))
        .get();
  }

  Future<Produto?> buscarPorId(String id) =>
      (select(produtos)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> inserir(ProdutosCompanion companion) =>
      into(produtos).insert(companion);

  Future<void> atualizar(ProdutosCompanion companion) =>
      (update(produtos)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deletar(String id) =>
      (delete(produtos)..where((t) => t.id.equals(id))).go();

  Future<bool> possuiRegistros(String produtoId) async {
    final query = select(registrosDePreco)
      ..where((t) => t.produtoId.equals(produtoId))
      ..limit(1);
    final result = await query.get();
    return result.isNotEmpty;
  }
}
