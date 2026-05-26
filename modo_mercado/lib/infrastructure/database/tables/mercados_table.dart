import 'package:drift/drift.dart';

class Mercados extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
