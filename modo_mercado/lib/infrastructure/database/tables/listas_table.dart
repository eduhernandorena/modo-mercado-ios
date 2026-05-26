import 'package:drift/drift.dart';

class ListasDeCompras extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
