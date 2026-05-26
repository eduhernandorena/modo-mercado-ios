import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/produtos_table.dart';
import 'tables/mercados_table.dart';
import 'tables/registros_table.dart';
import 'tables/listas_table.dart';
import 'tables/itens_table.dart';
import 'daos/produto_dao.dart';
import 'daos/mercado_dao.dart';
import 'daos/registro_dao.dart';
import 'daos/lista_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Produtos, Mercados, RegistrosDePreco, ListasDeCompras, ItensDeLista],
  daos: [ProdutoDao, MercadoDao, RegistroDao, ListaDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'modo_mercado');
  }

  /// Cria um banco em memória para testes.
  static AppDatabase inMemory() {
    return AppDatabase(NativeDatabase.memory());
  }
}
