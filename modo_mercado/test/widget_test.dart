// Smoke test: verifica que os modelos de domínio principais instanciam corretamente.
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/core/domain/models/produto.dart';
import 'package:modo_mercado/core/domain/models/lista_de_compras.dart';
import 'package:modo_mercado/core/domain/models/item_de_lista.dart';

void main() {
  test('Produto instancia corretamente', () {
    final now = DateTime.now();
    final produto = Produto(
      id: 'id-1',
      nome: 'Arroz',
      categoria: 'Grãos',
      unidade: 'kg',
      criadoEm: now,
      atualizadoEm: now,
    );
    expect(produto.nome, equals('Arroz'));
    expect(produto.categoria, equals('Grãos'));
  });

  test('ListaDeCompras calcula totalEstimadoCentavos corretamente', () {
    const item1 = ItemDeLista(
      id: 'i1',
      produtoId: 'p1',
      quantidade: 2.0,
      concluido: false,
      ultimoPrecoRegistradoCentavos: 1000,
    );
    const item2 = ItemDeLista(
      id: 'i2',
      produtoId: 'p2',
      quantidade: 3.0,
      concluido: true,
      ultimoPrecoRegistradoCentavos: 500,
    );
    const itemSemPreco = ItemDeLista(
      id: 'i3',
      produtoId: 'p3',
      quantidade: 1.0,
      concluido: false,
    );
    final now = DateTime.now();
    final lista = ListaDeCompras(
      id: 'l1',
      nome: 'Compras',
      itens: const [item1, item2, itemSemPreco],
      criadoEm: now,
      atualizadoEm: now,
    );
    // 2 * 1000 + 3 * 500 + 0 = 3500
    expect(lista.totalEstimadoCentavos, equals(3500));
  });
}
