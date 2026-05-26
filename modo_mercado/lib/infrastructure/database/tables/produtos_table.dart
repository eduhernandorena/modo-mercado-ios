import 'package:drift/drift.dart';

class Produtos extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get categoria => text()();
  TextColumn get unidade => text()();
  TextColumn get marca => text().nullable()();
  RealColumn get quantidade => real().nullable()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
