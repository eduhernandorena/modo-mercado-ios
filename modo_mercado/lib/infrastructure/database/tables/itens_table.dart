import 'package:drift/drift.dart';
import 'listas_table.dart';

class ItensDeLista extends Table {
  TextColumn get id => text()();
  TextColumn get listaId => text().references(ListasDeCompras, #id)();
  TextColumn get produtoId => text()();
  RealColumn get quantidade => real()();
  BoolColumn get concluido => boolean().withDefault(const Constant(false))();
  IntColumn get ultimoPrecoRegistradoCentavos => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
