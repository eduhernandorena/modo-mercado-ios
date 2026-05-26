// Fábricas de dados aleatórios para testes de propriedade.

import 'dart:math';
import 'package:faker/faker.dart';
import 'package:modo_mercado/core/domain/models/item_de_lista.dart';
import 'package:modo_mercado/core/domain/models/lista_de_compras.dart';
import 'package:modo_mercado/core/domain/models/mercado.dart';
import 'package:modo_mercado/core/domain/models/produto.dart';
import 'package:modo_mercado/core/domain/models/registro_de_preco.dart';
import 'package:uuid/uuid.dart';

final _faker = Faker();
final _random = Random();
const _uuid = Uuid();

Produto gerarProduto({String? nome, String? categoria}) => Produto(
      id: _uuid.v4(),
      nome: nome ?? _faker.food.dish(),
      categoria: categoria ?? _faker.lorem.word(),
      unidade: _faker.lorem.word(),
      marca: _random.nextBool() ? _faker.company.name() : null,
      quantidade: _random.nextBool() ? _random.nextDouble() * 10 + 0.1 : null,
      observacao: _random.nextBool() ? _faker.lorem.sentence() : null,
      criadoEm: _faker.date.dateTime(),
      atualizadoEm: _faker.date.dateTime(),
    );

Mercado gerarMercado() => Mercado(
      id: _uuid.v4(),
      nome: _faker.company.name(),
      criadoEm: _faker.date.dateTime(),
    );

RegistroDePreco gerarRegistro({
  required String produtoId,
  required String mercadoId,
  int? valorCentavos,
  DateTime? data,
}) =>
    RegistroDePreco(
      id: _uuid.v4(),
      produtoId: produtoId,
      mercadoId: mercadoId,
      valorCentavos: valorCentavos ?? (_random.nextInt(99999) + 1),
      data: data ?? _faker.date.dateTime(),
      fotoPath: null,
      criadoEm: _faker.date.dateTime(),
    );

/// [ultimoPreco] = null → sem preço (explícito)
/// [ultimoPreco] não fornecido → aleatório (com ou sem preço)
ItemDeLista gerarItem({String? produtoId, int? ultimoPreco, bool semPreco = false}) =>
    ItemDeLista(
      id: _uuid.v4(),
      produtoId: produtoId ?? _uuid.v4(),
      quantidade: _random.nextDouble() * 9 + 1,
      concluido: _random.nextBool(),
      ultimoPrecoRegistradoCentavos: semPreco
          ? null
          : (ultimoPreco ?? (_random.nextBool() ? _random.nextInt(99999) + 1 : null)),
    );

ListaDeCompras gerarLista({List<ItemDeLista>? itens}) => ListaDeCompras(
      id: _uuid.v4(),
      nome: _faker.lorem.sentence(),
      itens: itens ?? const [],
      criadoEm: _faker.date.dateTime(),
      atualizadoEm: _faker.date.dateTime(),
    );

List<Produto> gerarProdutos(int n) => List.generate(n, (_) => gerarProduto());

List<RegistroDePreco> gerarRegistrosAleatorios(
    String produtoId, String mercadoId, int n) =>
    List.generate(n, (_) => gerarRegistro(produtoId: produtoId, mercadoId: mercadoId));
