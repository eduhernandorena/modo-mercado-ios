// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProdutosTable extends Produtos with TableInfo<$ProdutosTable, Produto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdutosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadeMeta = const VerificationMeta(
    'unidade',
  );
  @override
  late final GeneratedColumn<String> unidade = GeneratedColumn<String>(
    'unidade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantidadeMeta = const VerificationMeta(
    'quantidade',
  );
  @override
  late final GeneratedColumn<double> quantidade = GeneratedColumn<double>(
    'quantidade',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observacaoMeta = const VerificationMeta(
    'observacao',
  );
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
    'observacao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    categoria,
    unidade,
    marca,
    quantidade,
    observacao,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produtos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Produto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('unidade')) {
      context.handle(
        _unidadeMeta,
        unidade.isAcceptableOrUnknown(data['unidade']!, _unidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadeMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    }
    if (data.containsKey('quantidade')) {
      context.handle(
        _quantidadeMeta,
        quantidade.isAcceptableOrUnknown(data['quantidade']!, _quantidadeMeta),
      );
    }
    if (data.containsKey('observacao')) {
      context.handle(
        _observacaoMeta,
        observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Produto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Produto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      unidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidade'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      ),
      quantidade: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantidade'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $ProdutosTable createAlias(String alias) {
    return $ProdutosTable(attachedDatabase, alias);
  }
}

class Produto extends DataClass implements Insertable<Produto> {
  final String id;
  final String nome;
  final String categoria;
  final String unidade;
  final String? marca;
  final double? quantidade;
  final String? observacao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.unidade,
    this.marca,
    this.quantidade,
    this.observacao,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['categoria'] = Variable<String>(categoria);
    map['unidade'] = Variable<String>(unidade);
    if (!nullToAbsent || marca != null) {
      map['marca'] = Variable<String>(marca);
    }
    if (!nullToAbsent || quantidade != null) {
      map['quantidade'] = Variable<double>(quantidade);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  ProdutosCompanion toCompanion(bool nullToAbsent) {
    return ProdutosCompanion(
      id: Value(id),
      nome: Value(nome),
      categoria: Value(categoria),
      unidade: Value(unidade),
      marca: marca == null && nullToAbsent
          ? const Value.absent()
          : Value(marca),
      quantidade: quantidade == null && nullToAbsent
          ? const Value.absent()
          : Value(quantidade),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory Produto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Produto(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoria: serializer.fromJson<String>(json['categoria']),
      unidade: serializer.fromJson<String>(json['unidade']),
      marca: serializer.fromJson<String?>(json['marca']),
      quantidade: serializer.fromJson<double?>(json['quantidade']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'categoria': serializer.toJson<String>(categoria),
      'unidade': serializer.toJson<String>(unidade),
      'marca': serializer.toJson<String?>(marca),
      'quantidade': serializer.toJson<double?>(quantidade),
      'observacao': serializer.toJson<String?>(observacao),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  Produto copyWith({
    String? id,
    String? nome,
    String? categoria,
    String? unidade,
    Value<String?> marca = const Value.absent(),
    Value<double?> quantidade = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Produto(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    categoria: categoria ?? this.categoria,
    unidade: unidade ?? this.unidade,
    marca: marca.present ? marca.value : this.marca,
    quantidade: quantidade.present ? quantidade.value : this.quantidade,
    observacao: observacao.present ? observacao.value : this.observacao,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  Produto copyWithCompanion(ProdutosCompanion data) {
    return Produto(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      unidade: data.unidade.present ? data.unidade.value : this.unidade,
      marca: data.marca.present ? data.marca.value : this.marca,
      quantidade: data.quantidade.present
          ? data.quantidade.value
          : this.quantidade,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Produto(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('unidade: $unidade, ')
          ..write('marca: $marca, ')
          ..write('quantidade: $quantidade, ')
          ..write('observacao: $observacao, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    categoria,
    unidade,
    marca,
    quantidade,
    observacao,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produto &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoria == this.categoria &&
          other.unidade == this.unidade &&
          other.marca == this.marca &&
          other.quantidade == this.quantidade &&
          other.observacao == this.observacao &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ProdutosCompanion extends UpdateCompanion<Produto> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> categoria;
  final Value<String> unidade;
  final Value<String?> marca;
  final Value<double?> quantidade;
  final Value<String?> observacao;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  final Value<int> rowid;
  const ProdutosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoria = const Value.absent(),
    this.unidade = const Value.absent(),
    this.marca = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.observacao = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProdutosCompanion.insert({
    required String id,
    required String nome,
    required String categoria,
    required String unidade,
    this.marca = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.observacao = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome),
       categoria = Value(categoria),
       unidade = Value(unidade),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Produto> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? categoria,
    Expression<String>? unidade,
    Expression<String>? marca,
    Expression<double>? quantidade,
    Expression<String>? observacao,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoria != null) 'categoria': categoria,
      if (unidade != null) 'unidade': unidade,
      if (marca != null) 'marca': marca,
      if (quantidade != null) 'quantidade': quantidade,
      if (observacao != null) 'observacao': observacao,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProdutosCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<String>? categoria,
    Value<String>? unidade,
    Value<String?>? marca,
    Value<double?>? quantidade,
    Value<String?>? observacao,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
    Value<int>? rowid,
  }) {
    return ProdutosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      unidade: unidade ?? this.unidade,
      marca: marca ?? this.marca,
      quantidade: quantidade ?? this.quantidade,
      observacao: observacao ?? this.observacao,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (unidade.present) {
      map['unidade'] = Variable<String>(unidade.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (quantidade.present) {
      map['quantidade'] = Variable<double>(quantidade.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdutosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('unidade: $unidade, ')
          ..write('marca: $marca, ')
          ..write('quantidade: $quantidade, ')
          ..write('observacao: $observacao, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MercadosTable extends Mercados with TableInfo<$MercadosTable, Mercado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MercadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mercados';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mercado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mercado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mercado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $MercadosTable createAlias(String alias) {
    return $MercadosTable(attachedDatabase, alias);
  }
}

class Mercado extends DataClass implements Insertable<Mercado> {
  final String id;
  final String nome;
  final DateTime criadoEm;
  const Mercado({required this.id, required this.nome, required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  MercadosCompanion toCompanion(bool nullToAbsent) {
    return MercadosCompanion(
      id: Value(id),
      nome: Value(nome),
      criadoEm: Value(criadoEm),
    );
  }

  factory Mercado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mercado(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Mercado copyWith({String? id, String? nome, DateTime? criadoEm}) => Mercado(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  Mercado copyWithCompanion(MercadosCompanion data) {
    return Mercado(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mercado(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mercado &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.criadoEm == this.criadoEm);
}

class MercadosCompanion extends UpdateCompanion<Mercado> {
  final Value<String> id;
  final Value<String> nome;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const MercadosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MercadosCompanion.insert({
    required String id,
    required String nome,
    required DateTime criadoEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome),
       criadoEm = Value(criadoEm);
  static Insertable<Mercado> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MercadosCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<DateTime>? criadoEm,
    Value<int>? rowid,
  }) {
    return MercadosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MercadosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegistrosDePrecoTable extends RegistrosDePreco
    with TableInfo<$RegistrosDePrecoTable, RegistrosDePrecoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosDePrecoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtoIdMeta = const VerificationMeta(
    'produtoId',
  );
  @override
  late final GeneratedColumn<String> produtoId = GeneratedColumn<String>(
    'produto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produtos (id)',
    ),
  );
  static const VerificationMeta _mercadoIdMeta = const VerificationMeta(
    'mercadoId',
  );
  @override
  late final GeneratedColumn<String> mercadoId = GeneratedColumn<String>(
    'mercado_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mercados (id)',
    ),
  );
  static const VerificationMeta _valorCentavosMeta = const VerificationMeta(
    'valorCentavos',
  );
  @override
  late final GeneratedColumn<int> valorCentavos = GeneratedColumn<int>(
    'valor_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fotoPathMeta = const VerificationMeta(
    'fotoPath',
  );
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
    'foto_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    produtoId,
    mercadoId,
    valorCentavos,
    data,
    fotoPath,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros_de_preco';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistrosDePrecoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('produto_id')) {
      context.handle(
        _produtoIdMeta,
        produtoId.isAcceptableOrUnknown(data['produto_id']!, _produtoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoIdMeta);
    }
    if (data.containsKey('mercado_id')) {
      context.handle(
        _mercadoIdMeta,
        mercadoId.isAcceptableOrUnknown(data['mercado_id']!, _mercadoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mercadoIdMeta);
    }
    if (data.containsKey('valor_centavos')) {
      context.handle(
        _valorCentavosMeta,
        valorCentavos.isAcceptableOrUnknown(
          data['valor_centavos']!,
          _valorCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorCentavosMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('foto_path')) {
      context.handle(
        _fotoPathMeta,
        fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistrosDePrecoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistrosDePrecoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      produtoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produto_id'],
      )!,
      mercadoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mercado_id'],
      )!,
      valorCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_centavos'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      fotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_path'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $RegistrosDePrecoTable createAlias(String alias) {
    return $RegistrosDePrecoTable(attachedDatabase, alias);
  }
}

class RegistrosDePrecoData extends DataClass
    implements Insertable<RegistrosDePrecoData> {
  final String id;
  final String produtoId;
  final String mercadoId;
  final int valorCentavos;
  final DateTime data;
  final String? fotoPath;
  final DateTime criadoEm;
  const RegistrosDePrecoData({
    required this.id,
    required this.produtoId,
    required this.mercadoId,
    required this.valorCentavos,
    required this.data,
    this.fotoPath,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['produto_id'] = Variable<String>(produtoId);
    map['mercado_id'] = Variable<String>(mercadoId);
    map['valor_centavos'] = Variable<int>(valorCentavos);
    map['data'] = Variable<DateTime>(data);
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  RegistrosDePrecoCompanion toCompanion(bool nullToAbsent) {
    return RegistrosDePrecoCompanion(
      id: Value(id),
      produtoId: Value(produtoId),
      mercadoId: Value(mercadoId),
      valorCentavos: Value(valorCentavos),
      data: Value(data),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      criadoEm: Value(criadoEm),
    );
  }

  factory RegistrosDePrecoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistrosDePrecoData(
      id: serializer.fromJson<String>(json['id']),
      produtoId: serializer.fromJson<String>(json['produtoId']),
      mercadoId: serializer.fromJson<String>(json['mercadoId']),
      valorCentavos: serializer.fromJson<int>(json['valorCentavos']),
      data: serializer.fromJson<DateTime>(json['data']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'produtoId': serializer.toJson<String>(produtoId),
      'mercadoId': serializer.toJson<String>(mercadoId),
      'valorCentavos': serializer.toJson<int>(valorCentavos),
      'data': serializer.toJson<DateTime>(data),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  RegistrosDePrecoData copyWith({
    String? id,
    String? produtoId,
    String? mercadoId,
    int? valorCentavos,
    DateTime? data,
    Value<String?> fotoPath = const Value.absent(),
    DateTime? criadoEm,
  }) => RegistrosDePrecoData(
    id: id ?? this.id,
    produtoId: produtoId ?? this.produtoId,
    mercadoId: mercadoId ?? this.mercadoId,
    valorCentavos: valorCentavos ?? this.valorCentavos,
    data: data ?? this.data,
    fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  RegistrosDePrecoData copyWithCompanion(RegistrosDePrecoCompanion data) {
    return RegistrosDePrecoData(
      id: data.id.present ? data.id.value : this.id,
      produtoId: data.produtoId.present ? data.produtoId.value : this.produtoId,
      mercadoId: data.mercadoId.present ? data.mercadoId.value : this.mercadoId,
      valorCentavos: data.valorCentavos.present
          ? data.valorCentavos.value
          : this.valorCentavos,
      data: data.data.present ? data.data.value : this.data,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosDePrecoData(')
          ..write('id: $id, ')
          ..write('produtoId: $produtoId, ')
          ..write('mercadoId: $mercadoId, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('data: $data, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    produtoId,
    mercadoId,
    valorCentavos,
    data,
    fotoPath,
    criadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistrosDePrecoData &&
          other.id == this.id &&
          other.produtoId == this.produtoId &&
          other.mercadoId == this.mercadoId &&
          other.valorCentavos == this.valorCentavos &&
          other.data == this.data &&
          other.fotoPath == this.fotoPath &&
          other.criadoEm == this.criadoEm);
}

class RegistrosDePrecoCompanion extends UpdateCompanion<RegistrosDePrecoData> {
  final Value<String> id;
  final Value<String> produtoId;
  final Value<String> mercadoId;
  final Value<int> valorCentavos;
  final Value<DateTime> data;
  final Value<String?> fotoPath;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const RegistrosDePrecoCompanion({
    this.id = const Value.absent(),
    this.produtoId = const Value.absent(),
    this.mercadoId = const Value.absent(),
    this.valorCentavos = const Value.absent(),
    this.data = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegistrosDePrecoCompanion.insert({
    required String id,
    required String produtoId,
    required String mercadoId,
    required int valorCentavos,
    required DateTime data,
    this.fotoPath = const Value.absent(),
    required DateTime criadoEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produtoId = Value(produtoId),
       mercadoId = Value(mercadoId),
       valorCentavos = Value(valorCentavos),
       data = Value(data),
       criadoEm = Value(criadoEm);
  static Insertable<RegistrosDePrecoData> custom({
    Expression<String>? id,
    Expression<String>? produtoId,
    Expression<String>? mercadoId,
    Expression<int>? valorCentavos,
    Expression<DateTime>? data,
    Expression<String>? fotoPath,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produtoId != null) 'produto_id': produtoId,
      if (mercadoId != null) 'mercado_id': mercadoId,
      if (valorCentavos != null) 'valor_centavos': valorCentavos,
      if (data != null) 'data': data,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegistrosDePrecoCompanion copyWith({
    Value<String>? id,
    Value<String>? produtoId,
    Value<String>? mercadoId,
    Value<int>? valorCentavos,
    Value<DateTime>? data,
    Value<String?>? fotoPath,
    Value<DateTime>? criadoEm,
    Value<int>? rowid,
  }) {
    return RegistrosDePrecoCompanion(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      mercadoId: mercadoId ?? this.mercadoId,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      data: data ?? this.data,
      fotoPath: fotoPath ?? this.fotoPath,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (produtoId.present) {
      map['produto_id'] = Variable<String>(produtoId.value);
    }
    if (mercadoId.present) {
      map['mercado_id'] = Variable<String>(mercadoId.value);
    }
    if (valorCentavos.present) {
      map['valor_centavos'] = Variable<int>(valorCentavos.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosDePrecoCompanion(')
          ..write('id: $id, ')
          ..write('produtoId: $produtoId, ')
          ..write('mercadoId: $mercadoId, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('data: $data, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListasDeComprasTable extends ListasDeCompras
    with TableInfo<$ListasDeComprasTable, ListasDeCompra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListasDeComprasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, criadoEm, atualizadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listas_de_compras';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListasDeCompra> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListasDeCompra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListasDeCompra(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $ListasDeComprasTable createAlias(String alias) {
    return $ListasDeComprasTable(attachedDatabase, alias);
  }
}

class ListasDeCompra extends DataClass implements Insertable<ListasDeCompra> {
  final String id;
  final String nome;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const ListasDeCompra({
    required this.id,
    required this.nome,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  ListasDeComprasCompanion toCompanion(bool nullToAbsent) {
    return ListasDeComprasCompanion(
      id: Value(id),
      nome: Value(nome),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory ListasDeCompra.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListasDeCompra(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  ListasDeCompra copyWith({
    String? id,
    String? nome,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => ListasDeCompra(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  ListasDeCompra copyWithCompanion(ListasDeComprasCompanion data) {
    return ListasDeCompra(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListasDeCompra(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, criadoEm, atualizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListasDeCompra &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ListasDeComprasCompanion extends UpdateCompanion<ListasDeCompra> {
  final Value<String> id;
  final Value<String> nome;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  final Value<int> rowid;
  const ListasDeComprasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListasDeComprasCompanion.insert({
    required String id,
    required String nome,
    required DateTime criadoEm,
    required DateTime atualizadoEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<ListasDeCompra> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListasDeComprasCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
    Value<int>? rowid,
  }) {
    return ListasDeComprasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListasDeComprasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItensDeListaTable extends ItensDeLista
    with TableInfo<$ItensDeListaTable, ItensDeListaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItensDeListaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listaIdMeta = const VerificationMeta(
    'listaId',
  );
  @override
  late final GeneratedColumn<String> listaId = GeneratedColumn<String>(
    'lista_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES listas_de_compras (id)',
    ),
  );
  static const VerificationMeta _produtoIdMeta = const VerificationMeta(
    'produtoId',
  );
  @override
  late final GeneratedColumn<String> produtoId = GeneratedColumn<String>(
    'produto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantidadeMeta = const VerificationMeta(
    'quantidade',
  );
  @override
  late final GeneratedColumn<double> quantidade = GeneratedColumn<double>(
    'quantidade',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _concluidoMeta = const VerificationMeta(
    'concluido',
  );
  @override
  late final GeneratedColumn<bool> concluido = GeneratedColumn<bool>(
    'concluido',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("concluido" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ultimoPrecoRegistradoCentavosMeta =
      const VerificationMeta('ultimoPrecoRegistradoCentavos');
  @override
  late final GeneratedColumn<int> ultimoPrecoRegistradoCentavos =
      GeneratedColumn<int>(
        'ultimo_preco_registrado_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listaId,
    produtoId,
    quantidade,
    concluido,
    ultimoPrecoRegistradoCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itens_de_lista';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItensDeListaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lista_id')) {
      context.handle(
        _listaIdMeta,
        listaId.isAcceptableOrUnknown(data['lista_id']!, _listaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listaIdMeta);
    }
    if (data.containsKey('produto_id')) {
      context.handle(
        _produtoIdMeta,
        produtoId.isAcceptableOrUnknown(data['produto_id']!, _produtoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoIdMeta);
    }
    if (data.containsKey('quantidade')) {
      context.handle(
        _quantidadeMeta,
        quantidade.isAcceptableOrUnknown(data['quantidade']!, _quantidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_quantidadeMeta);
    }
    if (data.containsKey('concluido')) {
      context.handle(
        _concluidoMeta,
        concluido.isAcceptableOrUnknown(data['concluido']!, _concluidoMeta),
      );
    }
    if (data.containsKey('ultimo_preco_registrado_centavos')) {
      context.handle(
        _ultimoPrecoRegistradoCentavosMeta,
        ultimoPrecoRegistradoCentavos.isAcceptableOrUnknown(
          data['ultimo_preco_registrado_centavos']!,
          _ultimoPrecoRegistradoCentavosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItensDeListaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItensDeListaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lista_id'],
      )!,
      produtoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produto_id'],
      )!,
      quantidade: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantidade'],
      )!,
      concluido: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}concluido'],
      )!,
      ultimoPrecoRegistradoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ultimo_preco_registrado_centavos'],
      ),
    );
  }

  @override
  $ItensDeListaTable createAlias(String alias) {
    return $ItensDeListaTable(attachedDatabase, alias);
  }
}

class ItensDeListaData extends DataClass
    implements Insertable<ItensDeListaData> {
  final String id;
  final String listaId;
  final String produtoId;
  final double quantidade;
  final bool concluido;
  final int? ultimoPrecoRegistradoCentavos;
  const ItensDeListaData({
    required this.id,
    required this.listaId,
    required this.produtoId,
    required this.quantidade,
    required this.concluido,
    this.ultimoPrecoRegistradoCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lista_id'] = Variable<String>(listaId);
    map['produto_id'] = Variable<String>(produtoId);
    map['quantidade'] = Variable<double>(quantidade);
    map['concluido'] = Variable<bool>(concluido);
    if (!nullToAbsent || ultimoPrecoRegistradoCentavos != null) {
      map['ultimo_preco_registrado_centavos'] = Variable<int>(
        ultimoPrecoRegistradoCentavos,
      );
    }
    return map;
  }

  ItensDeListaCompanion toCompanion(bool nullToAbsent) {
    return ItensDeListaCompanion(
      id: Value(id),
      listaId: Value(listaId),
      produtoId: Value(produtoId),
      quantidade: Value(quantidade),
      concluido: Value(concluido),
      ultimoPrecoRegistradoCentavos:
          ultimoPrecoRegistradoCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimoPrecoRegistradoCentavos),
    );
  }

  factory ItensDeListaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItensDeListaData(
      id: serializer.fromJson<String>(json['id']),
      listaId: serializer.fromJson<String>(json['listaId']),
      produtoId: serializer.fromJson<String>(json['produtoId']),
      quantidade: serializer.fromJson<double>(json['quantidade']),
      concluido: serializer.fromJson<bool>(json['concluido']),
      ultimoPrecoRegistradoCentavos: serializer.fromJson<int?>(
        json['ultimoPrecoRegistradoCentavos'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listaId': serializer.toJson<String>(listaId),
      'produtoId': serializer.toJson<String>(produtoId),
      'quantidade': serializer.toJson<double>(quantidade),
      'concluido': serializer.toJson<bool>(concluido),
      'ultimoPrecoRegistradoCentavos': serializer.toJson<int?>(
        ultimoPrecoRegistradoCentavos,
      ),
    };
  }

  ItensDeListaData copyWith({
    String? id,
    String? listaId,
    String? produtoId,
    double? quantidade,
    bool? concluido,
    Value<int?> ultimoPrecoRegistradoCentavos = const Value.absent(),
  }) => ItensDeListaData(
    id: id ?? this.id,
    listaId: listaId ?? this.listaId,
    produtoId: produtoId ?? this.produtoId,
    quantidade: quantidade ?? this.quantidade,
    concluido: concluido ?? this.concluido,
    ultimoPrecoRegistradoCentavos: ultimoPrecoRegistradoCentavos.present
        ? ultimoPrecoRegistradoCentavos.value
        : this.ultimoPrecoRegistradoCentavos,
  );
  ItensDeListaData copyWithCompanion(ItensDeListaCompanion data) {
    return ItensDeListaData(
      id: data.id.present ? data.id.value : this.id,
      listaId: data.listaId.present ? data.listaId.value : this.listaId,
      produtoId: data.produtoId.present ? data.produtoId.value : this.produtoId,
      quantidade: data.quantidade.present
          ? data.quantidade.value
          : this.quantidade,
      concluido: data.concluido.present ? data.concluido.value : this.concluido,
      ultimoPrecoRegistradoCentavos: data.ultimoPrecoRegistradoCentavos.present
          ? data.ultimoPrecoRegistradoCentavos.value
          : this.ultimoPrecoRegistradoCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItensDeListaData(')
          ..write('id: $id, ')
          ..write('listaId: $listaId, ')
          ..write('produtoId: $produtoId, ')
          ..write('quantidade: $quantidade, ')
          ..write('concluido: $concluido, ')
          ..write(
            'ultimoPrecoRegistradoCentavos: $ultimoPrecoRegistradoCentavos',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listaId,
    produtoId,
    quantidade,
    concluido,
    ultimoPrecoRegistradoCentavos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItensDeListaData &&
          other.id == this.id &&
          other.listaId == this.listaId &&
          other.produtoId == this.produtoId &&
          other.quantidade == this.quantidade &&
          other.concluido == this.concluido &&
          other.ultimoPrecoRegistradoCentavos ==
              this.ultimoPrecoRegistradoCentavos);
}

class ItensDeListaCompanion extends UpdateCompanion<ItensDeListaData> {
  final Value<String> id;
  final Value<String> listaId;
  final Value<String> produtoId;
  final Value<double> quantidade;
  final Value<bool> concluido;
  final Value<int?> ultimoPrecoRegistradoCentavos;
  final Value<int> rowid;
  const ItensDeListaCompanion({
    this.id = const Value.absent(),
    this.listaId = const Value.absent(),
    this.produtoId = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.concluido = const Value.absent(),
    this.ultimoPrecoRegistradoCentavos = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItensDeListaCompanion.insert({
    required String id,
    required String listaId,
    required String produtoId,
    required double quantidade,
    this.concluido = const Value.absent(),
    this.ultimoPrecoRegistradoCentavos = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listaId = Value(listaId),
       produtoId = Value(produtoId),
       quantidade = Value(quantidade);
  static Insertable<ItensDeListaData> custom({
    Expression<String>? id,
    Expression<String>? listaId,
    Expression<String>? produtoId,
    Expression<double>? quantidade,
    Expression<bool>? concluido,
    Expression<int>? ultimoPrecoRegistradoCentavos,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listaId != null) 'lista_id': listaId,
      if (produtoId != null) 'produto_id': produtoId,
      if (quantidade != null) 'quantidade': quantidade,
      if (concluido != null) 'concluido': concluido,
      if (ultimoPrecoRegistradoCentavos != null)
        'ultimo_preco_registrado_centavos': ultimoPrecoRegistradoCentavos,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItensDeListaCompanion copyWith({
    Value<String>? id,
    Value<String>? listaId,
    Value<String>? produtoId,
    Value<double>? quantidade,
    Value<bool>? concluido,
    Value<int?>? ultimoPrecoRegistradoCentavos,
    Value<int>? rowid,
  }) {
    return ItensDeListaCompanion(
      id: id ?? this.id,
      listaId: listaId ?? this.listaId,
      produtoId: produtoId ?? this.produtoId,
      quantidade: quantidade ?? this.quantidade,
      concluido: concluido ?? this.concluido,
      ultimoPrecoRegistradoCentavos:
          ultimoPrecoRegistradoCentavos ?? this.ultimoPrecoRegistradoCentavos,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listaId.present) {
      map['lista_id'] = Variable<String>(listaId.value);
    }
    if (produtoId.present) {
      map['produto_id'] = Variable<String>(produtoId.value);
    }
    if (quantidade.present) {
      map['quantidade'] = Variable<double>(quantidade.value);
    }
    if (concluido.present) {
      map['concluido'] = Variable<bool>(concluido.value);
    }
    if (ultimoPrecoRegistradoCentavos.present) {
      map['ultimo_preco_registrado_centavos'] = Variable<int>(
        ultimoPrecoRegistradoCentavos.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItensDeListaCompanion(')
          ..write('id: $id, ')
          ..write('listaId: $listaId, ')
          ..write('produtoId: $produtoId, ')
          ..write('quantidade: $quantidade, ')
          ..write('concluido: $concluido, ')
          ..write(
            'ultimoPrecoRegistradoCentavos: $ultimoPrecoRegistradoCentavos, ',
          )
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProdutosTable produtos = $ProdutosTable(this);
  late final $MercadosTable mercados = $MercadosTable(this);
  late final $RegistrosDePrecoTable registrosDePreco = $RegistrosDePrecoTable(
    this,
  );
  late final $ListasDeComprasTable listasDeCompras = $ListasDeComprasTable(
    this,
  );
  late final $ItensDeListaTable itensDeLista = $ItensDeListaTable(this);
  late final ProdutoDao produtoDao = ProdutoDao(this as AppDatabase);
  late final MercadoDao mercadoDao = MercadoDao(this as AppDatabase);
  late final RegistroDao registroDao = RegistroDao(this as AppDatabase);
  late final ListaDao listaDao = ListaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    produtos,
    mercados,
    registrosDePreco,
    listasDeCompras,
    itensDeLista,
  ];
}

typedef $$ProdutosTableCreateCompanionBuilder =
    ProdutosCompanion Function({
      required String id,
      required String nome,
      required String categoria,
      required String unidade,
      Value<String?> marca,
      Value<double?> quantidade,
      Value<String?> observacao,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
      Value<int> rowid,
    });
typedef $$ProdutosTableUpdateCompanionBuilder =
    ProdutosCompanion Function({
      Value<String> id,
      Value<String> nome,
      Value<String> categoria,
      Value<String> unidade,
      Value<String?> marca,
      Value<double?> quantidade,
      Value<String?> observacao,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
      Value<int> rowid,
    });

final class $$ProdutosTableReferences
    extends BaseReferences<_$AppDatabase, $ProdutosTable, Produto> {
  $$ProdutosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RegistrosDePrecoTable, List<RegistrosDePrecoData>>
  _registrosDePrecoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.registrosDePreco,
    aliasName: $_aliasNameGenerator(
      db.produtos.id,
      db.registrosDePreco.produtoId,
    ),
  );

  $$RegistrosDePrecoTableProcessedTableManager get registrosDePrecoRefs {
    final manager = $$RegistrosDePrecoTableTableManager(
      $_db,
      $_db.registrosDePreco,
    ).filter((f) => f.produtoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _registrosDePrecoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProdutosTableFilterComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> registrosDePrecoRefs(
    Expression<bool> Function($$RegistrosDePrecoTableFilterComposer f) f,
  ) {
    final $$RegistrosDePrecoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registrosDePreco,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosDePrecoTableFilterComposer(
            $db: $db,
            $table: $db.registrosDePreco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdutosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdutosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get unidade =>
      $composableBuilder(column: $table.unidade, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  Expression<T> registrosDePrecoRefs<T extends Object>(
    Expression<T> Function($$RegistrosDePrecoTableAnnotationComposer a) f,
  ) {
    final $$RegistrosDePrecoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registrosDePreco,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosDePrecoTableAnnotationComposer(
            $db: $db,
            $table: $db.registrosDePreco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdutosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdutosTable,
          Produto,
          $$ProdutosTableFilterComposer,
          $$ProdutosTableOrderingComposer,
          $$ProdutosTableAnnotationComposer,
          $$ProdutosTableCreateCompanionBuilder,
          $$ProdutosTableUpdateCompanionBuilder,
          (Produto, $$ProdutosTableReferences),
          Produto,
          PrefetchHooks Function({bool registrosDePrecoRefs})
        > {
  $$ProdutosTableTableManager(_$AppDatabase db, $ProdutosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdutosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdutosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdutosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String> unidade = const Value.absent(),
                Value<String?> marca = const Value.absent(),
                Value<double?> quantidade = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdutosCompanion(
                id: id,
                nome: nome,
                categoria: categoria,
                unidade: unidade,
                marca: marca,
                quantidade: quantidade,
                observacao: observacao,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nome,
                required String categoria,
                required String unidade,
                Value<String?> marca = const Value.absent(),
                Value<double?> quantidade = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
                Value<int> rowid = const Value.absent(),
              }) => ProdutosCompanion.insert(
                id: id,
                nome: nome,
                categoria: categoria,
                unidade: unidade,
                marca: marca,
                quantidade: quantidade,
                observacao: observacao,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProdutosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({registrosDePrecoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (registrosDePrecoRefs) db.registrosDePreco,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (registrosDePrecoRefs)
                    await $_getPrefetchedData<
                      Produto,
                      $ProdutosTable,
                      RegistrosDePrecoData
                    >(
                      currentTable: table,
                      referencedTable: $$ProdutosTableReferences
                          ._registrosDePrecoRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProdutosTableReferences(
                        db,
                        table,
                        p0,
                      ).registrosDePrecoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.produtoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProdutosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdutosTable,
      Produto,
      $$ProdutosTableFilterComposer,
      $$ProdutosTableOrderingComposer,
      $$ProdutosTableAnnotationComposer,
      $$ProdutosTableCreateCompanionBuilder,
      $$ProdutosTableUpdateCompanionBuilder,
      (Produto, $$ProdutosTableReferences),
      Produto,
      PrefetchHooks Function({bool registrosDePrecoRefs})
    >;
typedef $$MercadosTableCreateCompanionBuilder =
    MercadosCompanion Function({
      required String id,
      required String nome,
      required DateTime criadoEm,
      Value<int> rowid,
    });
typedef $$MercadosTableUpdateCompanionBuilder =
    MercadosCompanion Function({
      Value<String> id,
      Value<String> nome,
      Value<DateTime> criadoEm,
      Value<int> rowid,
    });

final class $$MercadosTableReferences
    extends BaseReferences<_$AppDatabase, $MercadosTable, Mercado> {
  $$MercadosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RegistrosDePrecoTable, List<RegistrosDePrecoData>>
  _registrosDePrecoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.registrosDePreco,
    aliasName: $_aliasNameGenerator(
      db.mercados.id,
      db.registrosDePreco.mercadoId,
    ),
  );

  $$RegistrosDePrecoTableProcessedTableManager get registrosDePrecoRefs {
    final manager = $$RegistrosDePrecoTableTableManager(
      $_db,
      $_db.registrosDePreco,
    ).filter((f) => f.mercadoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _registrosDePrecoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MercadosTableFilterComposer
    extends Composer<_$AppDatabase, $MercadosTable> {
  $$MercadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> registrosDePrecoRefs(
    Expression<bool> Function($$RegistrosDePrecoTableFilterComposer f) f,
  ) {
    final $$RegistrosDePrecoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registrosDePreco,
      getReferencedColumn: (t) => t.mercadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosDePrecoTableFilterComposer(
            $db: $db,
            $table: $db.registrosDePreco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MercadosTableOrderingComposer
    extends Composer<_$AppDatabase, $MercadosTable> {
  $$MercadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MercadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MercadosTable> {
  $$MercadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> registrosDePrecoRefs<T extends Object>(
    Expression<T> Function($$RegistrosDePrecoTableAnnotationComposer a) f,
  ) {
    final $$RegistrosDePrecoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registrosDePreco,
      getReferencedColumn: (t) => t.mercadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosDePrecoTableAnnotationComposer(
            $db: $db,
            $table: $db.registrosDePreco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MercadosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MercadosTable,
          Mercado,
          $$MercadosTableFilterComposer,
          $$MercadosTableOrderingComposer,
          $$MercadosTableAnnotationComposer,
          $$MercadosTableCreateCompanionBuilder,
          $$MercadosTableUpdateCompanionBuilder,
          (Mercado, $$MercadosTableReferences),
          Mercado,
          PrefetchHooks Function({bool registrosDePrecoRefs})
        > {
  $$MercadosTableTableManager(_$AppDatabase db, $MercadosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MercadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MercadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MercadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MercadosCompanion(
                id: id,
                nome: nome,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nome,
                required DateTime criadoEm,
                Value<int> rowid = const Value.absent(),
              }) => MercadosCompanion.insert(
                id: id,
                nome: nome,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MercadosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({registrosDePrecoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (registrosDePrecoRefs) db.registrosDePreco,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (registrosDePrecoRefs)
                    await $_getPrefetchedData<
                      Mercado,
                      $MercadosTable,
                      RegistrosDePrecoData
                    >(
                      currentTable: table,
                      referencedTable: $$MercadosTableReferences
                          ._registrosDePrecoRefsTable(db),
                      managerFromTypedResult: (p0) => $$MercadosTableReferences(
                        db,
                        table,
                        p0,
                      ).registrosDePrecoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mercadoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MercadosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MercadosTable,
      Mercado,
      $$MercadosTableFilterComposer,
      $$MercadosTableOrderingComposer,
      $$MercadosTableAnnotationComposer,
      $$MercadosTableCreateCompanionBuilder,
      $$MercadosTableUpdateCompanionBuilder,
      (Mercado, $$MercadosTableReferences),
      Mercado,
      PrefetchHooks Function({bool registrosDePrecoRefs})
    >;
typedef $$RegistrosDePrecoTableCreateCompanionBuilder =
    RegistrosDePrecoCompanion Function({
      required String id,
      required String produtoId,
      required String mercadoId,
      required int valorCentavos,
      required DateTime data,
      Value<String?> fotoPath,
      required DateTime criadoEm,
      Value<int> rowid,
    });
typedef $$RegistrosDePrecoTableUpdateCompanionBuilder =
    RegistrosDePrecoCompanion Function({
      Value<String> id,
      Value<String> produtoId,
      Value<String> mercadoId,
      Value<int> valorCentavos,
      Value<DateTime> data,
      Value<String?> fotoPath,
      Value<DateTime> criadoEm,
      Value<int> rowid,
    });

final class $$RegistrosDePrecoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RegistrosDePrecoTable,
          RegistrosDePrecoData
        > {
  $$RegistrosDePrecoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProdutosTable _produtoIdTable(_$AppDatabase db) =>
      db.produtos.createAlias(
        $_aliasNameGenerator(db.registrosDePreco.produtoId, db.produtos.id),
      );

  $$ProdutosTableProcessedTableManager get produtoId {
    final $_column = $_itemColumn<String>('produto_id')!;

    final manager = $$ProdutosTableTableManager(
      $_db,
      $_db.produtos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produtoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MercadosTable _mercadoIdTable(_$AppDatabase db) =>
      db.mercados.createAlias(
        $_aliasNameGenerator(db.registrosDePreco.mercadoId, db.mercados.id),
      );

  $$MercadosTableProcessedTableManager get mercadoId {
    final $_column = $_itemColumn<String>('mercado_id')!;

    final manager = $$MercadosTableTableManager(
      $_db,
      $_db.mercados,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mercadoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RegistrosDePrecoTableFilterComposer
    extends Composer<_$AppDatabase, $RegistrosDePrecoTable> {
  $$RegistrosDePrecoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ProdutosTableFilterComposer get produtoId {
    final $$ProdutosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableFilterComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MercadosTableFilterComposer get mercadoId {
    final $$MercadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mercadoId,
      referencedTable: $db.mercados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MercadosTableFilterComposer(
            $db: $db,
            $table: $db.mercados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosDePrecoTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistrosDePrecoTable> {
  $$RegistrosDePrecoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProdutosTableOrderingComposer get produtoId {
    final $$ProdutosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableOrderingComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MercadosTableOrderingComposer get mercadoId {
    final $$MercadosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mercadoId,
      referencedTable: $db.mercados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MercadosTableOrderingComposer(
            $db: $db,
            $table: $db.mercados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosDePrecoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistrosDePrecoTable> {
  $$RegistrosDePrecoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$ProdutosTableAnnotationComposer get produtoId {
    final $$ProdutosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableAnnotationComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MercadosTableAnnotationComposer get mercadoId {
    final $$MercadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mercadoId,
      referencedTable: $db.mercados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MercadosTableAnnotationComposer(
            $db: $db,
            $table: $db.mercados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosDePrecoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistrosDePrecoTable,
          RegistrosDePrecoData,
          $$RegistrosDePrecoTableFilterComposer,
          $$RegistrosDePrecoTableOrderingComposer,
          $$RegistrosDePrecoTableAnnotationComposer,
          $$RegistrosDePrecoTableCreateCompanionBuilder,
          $$RegistrosDePrecoTableUpdateCompanionBuilder,
          (RegistrosDePrecoData, $$RegistrosDePrecoTableReferences),
          RegistrosDePrecoData,
          PrefetchHooks Function({bool produtoId, bool mercadoId})
        > {
  $$RegistrosDePrecoTableTableManager(
    _$AppDatabase db,
    $RegistrosDePrecoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosDePrecoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosDePrecoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosDePrecoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> produtoId = const Value.absent(),
                Value<String> mercadoId = const Value.absent(),
                Value<int> valorCentavos = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosDePrecoCompanion(
                id: id,
                produtoId: produtoId,
                mercadoId: mercadoId,
                valorCentavos: valorCentavos,
                data: data,
                fotoPath: fotoPath,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String produtoId,
                required String mercadoId,
                required int valorCentavos,
                required DateTime data,
                Value<String?> fotoPath = const Value.absent(),
                required DateTime criadoEm,
                Value<int> rowid = const Value.absent(),
              }) => RegistrosDePrecoCompanion.insert(
                id: id,
                produtoId: produtoId,
                mercadoId: mercadoId,
                valorCentavos: valorCentavos,
                data: data,
                fotoPath: fotoPath,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RegistrosDePrecoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produtoId = false, mercadoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (produtoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.produtoId,
                                referencedTable:
                                    $$RegistrosDePrecoTableReferences
                                        ._produtoIdTable(db),
                                referencedColumn:
                                    $$RegistrosDePrecoTableReferences
                                        ._produtoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (mercadoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mercadoId,
                                referencedTable:
                                    $$RegistrosDePrecoTableReferences
                                        ._mercadoIdTable(db),
                                referencedColumn:
                                    $$RegistrosDePrecoTableReferences
                                        ._mercadoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RegistrosDePrecoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistrosDePrecoTable,
      RegistrosDePrecoData,
      $$RegistrosDePrecoTableFilterComposer,
      $$RegistrosDePrecoTableOrderingComposer,
      $$RegistrosDePrecoTableAnnotationComposer,
      $$RegistrosDePrecoTableCreateCompanionBuilder,
      $$RegistrosDePrecoTableUpdateCompanionBuilder,
      (RegistrosDePrecoData, $$RegistrosDePrecoTableReferences),
      RegistrosDePrecoData,
      PrefetchHooks Function({bool produtoId, bool mercadoId})
    >;
typedef $$ListasDeComprasTableCreateCompanionBuilder =
    ListasDeComprasCompanion Function({
      required String id,
      required String nome,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
      Value<int> rowid,
    });
typedef $$ListasDeComprasTableUpdateCompanionBuilder =
    ListasDeComprasCompanion Function({
      Value<String> id,
      Value<String> nome,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
      Value<int> rowid,
    });

final class $$ListasDeComprasTableReferences
    extends
        BaseReferences<_$AppDatabase, $ListasDeComprasTable, ListasDeCompra> {
  $$ListasDeComprasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ItensDeListaTable, List<ItensDeListaData>>
  _itensDeListaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itensDeLista,
    aliasName: $_aliasNameGenerator(
      db.listasDeCompras.id,
      db.itensDeLista.listaId,
    ),
  );

  $$ItensDeListaTableProcessedTableManager get itensDeListaRefs {
    final manager = $$ItensDeListaTableTableManager(
      $_db,
      $_db.itensDeLista,
    ).filter((f) => f.listaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itensDeListaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ListasDeComprasTableFilterComposer
    extends Composer<_$AppDatabase, $ListasDeComprasTable> {
  $$ListasDeComprasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itensDeListaRefs(
    Expression<bool> Function($$ItensDeListaTableFilterComposer f) f,
  ) {
    final $$ItensDeListaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensDeLista,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensDeListaTableFilterComposer(
            $db: $db,
            $table: $db.itensDeLista,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListasDeComprasTableOrderingComposer
    extends Composer<_$AppDatabase, $ListasDeComprasTable> {
  $$ListasDeComprasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListasDeComprasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListasDeComprasTable> {
  $$ListasDeComprasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  Expression<T> itensDeListaRefs<T extends Object>(
    Expression<T> Function($$ItensDeListaTableAnnotationComposer a) f,
  ) {
    final $$ItensDeListaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensDeLista,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensDeListaTableAnnotationComposer(
            $db: $db,
            $table: $db.itensDeLista,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListasDeComprasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListasDeComprasTable,
          ListasDeCompra,
          $$ListasDeComprasTableFilterComposer,
          $$ListasDeComprasTableOrderingComposer,
          $$ListasDeComprasTableAnnotationComposer,
          $$ListasDeComprasTableCreateCompanionBuilder,
          $$ListasDeComprasTableUpdateCompanionBuilder,
          (ListasDeCompra, $$ListasDeComprasTableReferences),
          ListasDeCompra,
          PrefetchHooks Function({bool itensDeListaRefs})
        > {
  $$ListasDeComprasTableTableManager(
    _$AppDatabase db,
    $ListasDeComprasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListasDeComprasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListasDeComprasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListasDeComprasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListasDeComprasCompanion(
                id: id,
                nome: nome,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nome,
                required DateTime criadoEm,
                required DateTime atualizadoEm,
                Value<int> rowid = const Value.absent(),
              }) => ListasDeComprasCompanion.insert(
                id: id,
                nome: nome,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ListasDeComprasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itensDeListaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itensDeListaRefs) db.itensDeLista],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itensDeListaRefs)
                    await $_getPrefetchedData<
                      ListasDeCompra,
                      $ListasDeComprasTable,
                      ItensDeListaData
                    >(
                      currentTable: table,
                      referencedTable: $$ListasDeComprasTableReferences
                          ._itensDeListaRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ListasDeComprasTableReferences(
                            db,
                            table,
                            p0,
                          ).itensDeListaRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ListasDeComprasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListasDeComprasTable,
      ListasDeCompra,
      $$ListasDeComprasTableFilterComposer,
      $$ListasDeComprasTableOrderingComposer,
      $$ListasDeComprasTableAnnotationComposer,
      $$ListasDeComprasTableCreateCompanionBuilder,
      $$ListasDeComprasTableUpdateCompanionBuilder,
      (ListasDeCompra, $$ListasDeComprasTableReferences),
      ListasDeCompra,
      PrefetchHooks Function({bool itensDeListaRefs})
    >;
typedef $$ItensDeListaTableCreateCompanionBuilder =
    ItensDeListaCompanion Function({
      required String id,
      required String listaId,
      required String produtoId,
      required double quantidade,
      Value<bool> concluido,
      Value<int?> ultimoPrecoRegistradoCentavos,
      Value<int> rowid,
    });
typedef $$ItensDeListaTableUpdateCompanionBuilder =
    ItensDeListaCompanion Function({
      Value<String> id,
      Value<String> listaId,
      Value<String> produtoId,
      Value<double> quantidade,
      Value<bool> concluido,
      Value<int?> ultimoPrecoRegistradoCentavos,
      Value<int> rowid,
    });

final class $$ItensDeListaTableReferences
    extends
        BaseReferences<_$AppDatabase, $ItensDeListaTable, ItensDeListaData> {
  $$ItensDeListaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ListasDeComprasTable _listaIdTable(_$AppDatabase db) =>
      db.listasDeCompras.createAlias(
        $_aliasNameGenerator(db.itensDeLista.listaId, db.listasDeCompras.id),
      );

  $$ListasDeComprasTableProcessedTableManager get listaId {
    final $_column = $_itemColumn<String>('lista_id')!;

    final manager = $$ListasDeComprasTableTableManager(
      $_db,
      $_db.listasDeCompras,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItensDeListaTableFilterComposer
    extends Composer<_$AppDatabase, $ItensDeListaTable> {
  $$ItensDeListaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produtoId => $composableBuilder(
    column: $table.produtoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get concluido => $composableBuilder(
    column: $table.concluido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ultimoPrecoRegistradoCentavos => $composableBuilder(
    column: $table.ultimoPrecoRegistradoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $$ListasDeComprasTableFilterComposer get listaId {
    final $$ListasDeComprasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listasDeCompras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasDeComprasTableFilterComposer(
            $db: $db,
            $table: $db.listasDeCompras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensDeListaTableOrderingComposer
    extends Composer<_$AppDatabase, $ItensDeListaTable> {
  $$ItensDeListaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produtoId => $composableBuilder(
    column: $table.produtoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get concluido => $composableBuilder(
    column: $table.concluido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ultimoPrecoRegistradoCentavos => $composableBuilder(
    column: $table.ultimoPrecoRegistradoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $$ListasDeComprasTableOrderingComposer get listaId {
    final $$ListasDeComprasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listasDeCompras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasDeComprasTableOrderingComposer(
            $db: $db,
            $table: $db.listasDeCompras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensDeListaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItensDeListaTable> {
  $$ItensDeListaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get produtoId =>
      $composableBuilder(column: $table.produtoId, builder: (column) => column);

  GeneratedColumn<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get concluido =>
      $composableBuilder(column: $table.concluido, builder: (column) => column);

  GeneratedColumn<int> get ultimoPrecoRegistradoCentavos => $composableBuilder(
    column: $table.ultimoPrecoRegistradoCentavos,
    builder: (column) => column,
  );

  $$ListasDeComprasTableAnnotationComposer get listaId {
    final $$ListasDeComprasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listasDeCompras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasDeComprasTableAnnotationComposer(
            $db: $db,
            $table: $db.listasDeCompras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensDeListaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItensDeListaTable,
          ItensDeListaData,
          $$ItensDeListaTableFilterComposer,
          $$ItensDeListaTableOrderingComposer,
          $$ItensDeListaTableAnnotationComposer,
          $$ItensDeListaTableCreateCompanionBuilder,
          $$ItensDeListaTableUpdateCompanionBuilder,
          (ItensDeListaData, $$ItensDeListaTableReferences),
          ItensDeListaData,
          PrefetchHooks Function({bool listaId})
        > {
  $$ItensDeListaTableTableManager(_$AppDatabase db, $ItensDeListaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItensDeListaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItensDeListaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItensDeListaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listaId = const Value.absent(),
                Value<String> produtoId = const Value.absent(),
                Value<double> quantidade = const Value.absent(),
                Value<bool> concluido = const Value.absent(),
                Value<int?> ultimoPrecoRegistradoCentavos =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItensDeListaCompanion(
                id: id,
                listaId: listaId,
                produtoId: produtoId,
                quantidade: quantidade,
                concluido: concluido,
                ultimoPrecoRegistradoCentavos: ultimoPrecoRegistradoCentavos,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listaId,
                required String produtoId,
                required double quantidade,
                Value<bool> concluido = const Value.absent(),
                Value<int?> ultimoPrecoRegistradoCentavos =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItensDeListaCompanion.insert(
                id: id,
                listaId: listaId,
                produtoId: produtoId,
                quantidade: quantidade,
                concluido: concluido,
                ultimoPrecoRegistradoCentavos: ultimoPrecoRegistradoCentavos,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ItensDeListaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listaId,
                                referencedTable: $$ItensDeListaTableReferences
                                    ._listaIdTable(db),
                                referencedColumn: $$ItensDeListaTableReferences
                                    ._listaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItensDeListaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItensDeListaTable,
      ItensDeListaData,
      $$ItensDeListaTableFilterComposer,
      $$ItensDeListaTableOrderingComposer,
      $$ItensDeListaTableAnnotationComposer,
      $$ItensDeListaTableCreateCompanionBuilder,
      $$ItensDeListaTableUpdateCompanionBuilder,
      (ItensDeListaData, $$ItensDeListaTableReferences),
      ItensDeListaData,
      PrefetchHooks Function({bool listaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProdutosTableTableManager get produtos =>
      $$ProdutosTableTableManager(_db, _db.produtos);
  $$MercadosTableTableManager get mercados =>
      $$MercadosTableTableManager(_db, _db.mercados);
  $$RegistrosDePrecoTableTableManager get registrosDePreco =>
      $$RegistrosDePrecoTableTableManager(_db, _db.registrosDePreco);
  $$ListasDeComprasTableTableManager get listasDeCompras =>
      $$ListasDeComprasTableTableManager(_db, _db.listasDeCompras);
  $$ItensDeListaTableTableManager get itensDeLista =>
      $$ItensDeListaTableTableManager(_db, _db.itensDeLista);
}
