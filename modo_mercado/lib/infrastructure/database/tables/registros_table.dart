import 'package:drift/drift.dart';
import 'produtos_table.dart';
import 'mercados_table.dart';

class RegistrosDePreco extends Table {
  TextColumn get id => text()();
  TextColumn get produtoId => text().references(Produtos, #id)();
  TextColumn get mercadoId => text().references(Mercados, #id)();
  IntColumn get valorCentavos => integer()();
  DateTimeColumn get data => dateTime()();
  TextColumn get fotoPath => text().nullable()();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
