// Implementações in-memory dos repositórios para testes de use cases.
// Não dependem de banco de dados — armazenam dados em listas em memória.

import 'package:modo_mercado/core/domain/models/lista_de_compras.dart';
import 'package:modo_mercado/core/domain/models/mercado.dart';
import 'package:modo_mercado/core/domain/models/produto.dart';
import 'package:modo_mercado/core/domain/models/registro_de_preco.dart';
import 'package:modo_mercado/core/protocols/lista_repository.dart';
import 'package:modo_mercado/core/protocols/mercado_repository.dart';
import 'package:modo_mercado/core/protocols/produto_repository.dart';
import 'package:modo_mercado/core/protocols/registro_repository.dart';

class InMemoryProdutoRepository implements ProdutoRepository {
  final List<Produto> _produtos = [];

  @override
  Future<List<Produto>> listar() async => List.unmodifiable(_produtos);

  @override
  Future<List<Produto>> buscar(String termo) async {
    final t = termo.toLowerCase();
    return _produtos
        .where((p) =>
            p.nome.toLowerCase().contains(t) ||
            p.categoria.toLowerCase().contains(t))
        .toList();
  }

  @override
  Future<void> salvar(Produto produto) async => _produtos.add(produto);

  @override
  Future<void> atualizar(Produto produto) async {
    final i = _produtos.indexWhere((p) => p.id == produto.id);
    if (i >= 0) _produtos[i] = produto;
  }

  @override
  Future<void> excluir(String id) async =>
      _produtos.removeWhere((p) => p.id == id);

  @override
  Future<bool> possuiRegistros(String produtoId) async => false;

  void clear() => _produtos.clear();
}

class InMemoryRegistroRepository implements RegistroRepository {
  final List<RegistroDePreco> _registros = [];

  @override
  Future<List<RegistroDePreco>> listarPorProduto(String produtoId) async =>
      _registros.where((r) => r.produtoId == produtoId).toList();

  @override
  Future<List<RegistroDePreco>> listarPorMercado(String mercadoId) async =>
      _registros.where((r) => r.mercadoId == mercadoId).toList();

  @override
  Future<List<RegistroDePreco>> listarPorPeriodo(
      DateTime inicio, DateTime fim) async =>
      _registros
          .where((r) => !r.data.isBefore(inicio) && !r.data.isAfter(fim))
          .toList();

  @override
  Future<void> salvar(RegistroDePreco registro) async =>
      _registros.add(registro);

  @override
  Future<void> excluir(String id) async =>
      _registros.removeWhere((r) => r.id == id);

  @override
  Future<RegistroDePreco?> ultimoPreco(
      String produtoId, String mercadoId) async {
    final lista = _registros
        .where((r) => r.produtoId == produtoId && r.mercadoId == mercadoId)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
    return lista.isEmpty ? null : lista.first;
  }

  void clear() => _registros.clear();
  void addAll(List<RegistroDePreco> registros) => _registros.addAll(registros);
}

class InMemoryMercadoRepository implements MercadoRepository {
  final List<Mercado> _mercados = [];

  @override
  Future<List<Mercado>> listar() async => List.unmodifiable(_mercados);

  @override
  Future<void> salvar(Mercado mercado) async => _mercados.add(mercado);

  @override
  Future<void> excluir(String id) async =>
      _mercados.removeWhere((m) => m.id == id);

  void addAll(List<Mercado> mercados) => _mercados.addAll(mercados);
  void clear() => _mercados.clear();
}

class InMemoryListaRepository implements ListaRepository {
  final List<ListaDeCompras> _listas = [];

  @override
  Future<List<ListaDeCompras>> listar() async => List.unmodifiable(_listas);

  @override
  Future<void> salvar(ListaDeCompras lista) async => _listas.add(lista);

  @override
  Future<void> atualizar(ListaDeCompras lista) async {
    final i = _listas.indexWhere((l) => l.id == lista.id);
    if (i >= 0) _listas[i] = lista;
  }

  @override
  Future<void> excluir(String id) async =>
      _listas.removeWhere((l) => l.id == id);

  void clear() => _listas.clear();
}
