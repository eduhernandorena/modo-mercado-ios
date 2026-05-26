// Feature: modo-mercado, Property 1: Round-trip de serialização de entidades
//
// Valida: Requisitos 3.10, 3.11, 7.4, 7.5, 7.6
//
// Verifica que salvar uma entidade no banco Drift e recuperá-la produz
// um objeto equivalente ao original (==) para todas as entidades de domínio.

import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/infrastructure/database/app_database.dart';
import 'package:modo_mercado/core/domain/models/produto.dart' as domain;
import 'package:modo_mercado/core/domain/models/registro_de_preco.dart'
    as domain;
import 'package:modo_mercado/core/domain/models/mercado.dart' as domain;
import 'package:modo_mercado/core/domain/models/item_de_lista.dart' as domain;
import 'package:modo_mercado/core/domain/models/lista_de_compras.dart'
    as domain;
import 'package:sqlite3/open.dart';
import 'package:uuid/uuid.dart';

/// No Linux de CI/dev, o pacote sqlite3 procura por 'libsqlite3.so' mas o
/// sistema só tem 'libsqlite3.so.0'. Sobrescrevemos o carregamento para
/// apontar ao arquivo versionado correto.
void _configurarSqlite3Linux() {
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      // Tenta primeiro o nome sem versão (caso libsqlite3-dev esteja instalado)
      for (final nome in [
        'libsqlite3.so',
        'libsqlite3.so.0',
      ]) {
        try {
          return DynamicLibrary.open(nome);
        } on ArgumentError {
          continue;
        }
      }
      throw UnsupportedError(
          'Não foi possível carregar libsqlite3. '
          'Instale libsqlite3-dev ou libsqlite3-0.');
    });
  }
}

/// Drift armazena DateTime como Unix timestamp em segundos (inteiro).
/// Normaliza para precisão de segundos para que a comparação seja válida.
DateTime _norm(DateTime dt) =>
    DateTime.fromMillisecondsSinceEpoch(
      (dt.millisecondsSinceEpoch ~/ 1000) * 1000,
      isUtc: dt.isUtc,
    );

void main() {
  // Garante que o sqlite3 seja carregado corretamente no Linux de dev/CI
  _configurarSqlite3Linux();

  late AppDatabase db;
  final faker = Faker();
  const uuid = Uuid();

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ---------------------------------------------------------------------------
  // Helpers para gerar entidades aleatórias com datas normalizadas
  // ---------------------------------------------------------------------------

  domain.Produto gerarProduto() => domain.Produto(
        id: uuid.v4(),
        nome: faker.food.dish(),
        categoria: faker.lorem.word(),
        unidade: faker.lorem.word(),
        marca: faker.randomGenerator.boolean() ? faker.company.name() : null,
        quantidade: faker.randomGenerator.boolean()
            ? faker.randomGenerator.decimal(scale: 10) + 0.1
            : null,
        observacao:
            faker.randomGenerator.boolean() ? faker.lorem.sentence() : null,
        criadoEm: _norm(faker.date.dateTime()),
        atualizadoEm: _norm(faker.date.dateTime()),
      );

  domain.Mercado gerarMercado() => domain.Mercado(
        id: uuid.v4(),
        nome: faker.company.name(),
        criadoEm: _norm(faker.date.dateTime()),
      );

  domain.RegistroDePreco gerarRegistro({
    required String produtoId,
    required String mercadoId,
  }) =>
      domain.RegistroDePreco(
        id: uuid.v4(),
        produtoId: produtoId,
        mercadoId: mercadoId,
        valorCentavos: faker.randomGenerator.integer(100000, min: 1),
        data: _norm(faker.date.dateTime()),
        fotoPath: faker.randomGenerator.boolean()
            ? faker.internet.uri('https')
            : null,
        criadoEm: _norm(faker.date.dateTime()),
      );

  domain.ItemDeLista gerarItem() => domain.ItemDeLista(
        id: uuid.v4(),
        produtoId: uuid.v4(),
        quantidade: faker.randomGenerator.decimal(scale: 10) + 0.1,
        concluido: faker.randomGenerator.boolean(),
        ultimoPrecoRegistradoCentavos: faker.randomGenerator.boolean()
            ? faker.randomGenerator.integer(100000, min: 1)
            : null,
      );

  // ---------------------------------------------------------------------------
  // Testes de propriedade
  // ---------------------------------------------------------------------------

  group('Property 1: Round-trip de serialização de entidades', () {
    test(
        'Produto: toDomain(toCompanion(p)) == p para 100 instâncias aleatórias',
        () async {
      // Feature: modo-mercado, Property 1: Round-trip de serialização de entidades
      for (var i = 0; i < 100; i++) {
        final original = gerarProduto();
        await db.produtoDao.inserir(db.produtoDao.toCompanion(original));
        final row = await db.produtoDao.buscarPorId(original.id);
        expect(row, isNotNull,
            reason: 'Iteração $i: produto ${original.id} não encontrado');
        final recuperado = db.produtoDao.toDomain(row!);
        expect(recuperado, equals(original),
            reason:
                'Iteração $i: round-trip falhou para Produto ${original.id}');
        await db.produtoDao.deletar(original.id);
      }
    });

    test('Mercado: round-trip para 100 instâncias aleatórias', () async {
      // Feature: modo-mercado, Property 1: Round-trip de serialização de entidades
      for (var i = 0; i < 100; i++) {
        final original = gerarMercado();
        await db.mercadoDao.inserir(db.mercadoDao.toCompanion(original));
        final row = await db.mercadoDao.buscarPorId(original.id);
        expect(row, isNotNull,
            reason: 'Iteração $i: mercado ${original.id} não encontrado');
        final recuperado = db.mercadoDao.toDomain(row!);
        expect(recuperado, equals(original),
            reason:
                'Iteração $i: round-trip falhou para Mercado ${original.id}');
        await db.mercadoDao.deletar(original.id);
      }
    });

    test('RegistroDePreco: round-trip para 100 instâncias aleatórias',
        () async {
      // Feature: modo-mercado, Property 1: Round-trip de serialização de entidades
      // Precisa de produto e mercado existentes por causa das foreign keys
      final produto = gerarProduto();
      final mercado = gerarMercado();
      await db.produtoDao.inserir(db.produtoDao.toCompanion(produto));
      await db.mercadoDao.inserir(db.mercadoDao.toCompanion(mercado));

      for (var i = 0; i < 100; i++) {
        final original = gerarRegistro(
          produtoId: produto.id,
          mercadoId: mercado.id,
        );
        await db.registroDao.inserir(db.registroDao.toCompanion(original));
        final rows = await db.registroDao.listarPorProduto(produto.id);
        final row = rows.firstWhere((r) => r.id == original.id);
        final recuperado = db.registroDao.toDomain(row);
        expect(recuperado, equals(original),
            reason:
                'Iteração $i: round-trip falhou para RegistroDePreco ${original.id}');
        await db.registroDao.deletar(original.id);
      }
    });

    test('ItemDeLista: round-trip para 100 instâncias aleatórias', () async {
      // Feature: modo-mercado, Property 1: Round-trip de serialização de entidades
      // Precisa de uma lista existente por causa da foreign key
      final listaId = uuid.v4();
      await db.listaDao.inserirLista(
        db.listaDao.listaToCompanion(
          domain.ListaDeCompras(
            id: listaId,
            nome: 'Lista Teste',
            itens: [],
            criadoEm: _norm(DateTime.now()),
            atualizadoEm: _norm(DateTime.now()),
          ),
        ),
      );

      for (var i = 0; i < 100; i++) {
        final original = gerarItem();
        await db.listaDao
            .inserirItem(db.listaDao.itemToCompanion(original, listaId));
        final rows = await db.listaDao.listarItensDaLista(listaId);
        final row = rows.firstWhere((item) => item.id == original.id);
        final recuperado = db.listaDao.itemToDomain(row);
        expect(recuperado, equals(original),
            reason:
                'Iteração $i: round-trip falhou para ItemDeLista ${original.id}');
        await db.listaDao.deletarItem(original.id);
      }
    });

    test(
        'ListaDeCompras (sem itens): round-trip para 100 instâncias aleatórias',
        () async {
      // Feature: modo-mercado, Property 1: Round-trip de serialização de entidades
      for (var i = 0; i < 100; i++) {
        final original = domain.ListaDeCompras(
          id: uuid.v4(),
          nome: faker.lorem.sentence(),
          itens: [],
          criadoEm: _norm(faker.date.dateTime()),
          atualizadoEm: _norm(faker.date.dateTime()),
        );
        await db.listaDao.inserirLista(db.listaDao.listaToCompanion(original));
        final listas = await db.listaDao.listarTodasListas();
        final row = listas.firstWhere((l) => l.id == original.id);
        // ListaDeCompras sem itens — compara campos individualmente
        expect(row.id, equals(original.id),
            reason: 'Iteração $i: id diverge');
        expect(row.nome, equals(original.nome),
            reason: 'Iteração $i: nome diverge');
        expect(row.criadoEm, equals(original.criadoEm),
            reason: 'Iteração $i: criadoEm diverge');
        expect(row.atualizadoEm, equals(original.atualizadoEm),
            reason: 'Iteração $i: atualizadoEm diverge');
        await db.listaDao.deletarLista(original.id);
      }
    });
  });
}
