// Feature: modo-mercado, Property 7: Estimativa de total da lista de compras
// Valida: Requisito 4.7

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/features/lista_de_compras/domain/use_cases/calcular_total_use_case.dart';
import '../../helpers/test_factories.dart';

void main() {
  final calcular = const CalcularTotalUseCase();
  final random = Random();

  group('Property 7: Estimativa de total da lista de compras', () {
    test(
        'totalEstimado == soma(preco * quantidade).round() apenas para itens com preço (100 iterações)',
        () {
      // Feature: modo-mercado, Property 7: Estimativa de total da lista de compras
      for (var i = 0; i < 100; i++) {
        final n = random.nextInt(20) + 1;
        final itens = List.generate(n, (_) => gerarItem());
        final lista = gerarLista(itens: itens);

        final totalCalculado = calcular.executar(lista);

        // Calcular manualmente: apenas itens com preço não-nulo
        var totalEsperado = 0;
        for (final item in itens) {
          final preco = item.ultimoPrecoRegistradoCentavos;
          if (preco != null) {
            totalEsperado += (preco * item.quantidade).round();
          }
        }

        expect(totalCalculado, equals(totalEsperado),
            reason: 'Iteração $i: total calculado ($totalCalculado) != esperado ($totalEsperado)');
      }
    });

    test('Itens sem preço não contribuem para o total (100 iterações)', () {
      // Feature: modo-mercado, Property 7: Estimativa de total da lista de compras
      for (var i = 0; i < 100; i++) {
        final itensSemPreco = List.generate(
          random.nextInt(10) + 1,
          (_) => gerarItem(semPreco: true),
        );
        final lista = gerarLista(itens: itensSemPreco);

        expect(calcular.executar(lista), equals(0),
            reason: 'Iteração $i: lista com apenas itens sem preço deve ter total 0');
      }
    });

    test('Itens concluídos ainda contribuem para o total (100 iterações)', () {
      // Feature: modo-mercado, Property 7: Estimativa de total da lista de compras
      for (var i = 0; i < 100; i++) {
        final preco = random.nextInt(9999) + 1;
        final quantidade = random.nextDouble() * 9 + 1;
        final itemConcluido = gerarItem(ultimoPreco: preco).copyWith(
          concluido: true,
          quantidade: quantidade,
        );
        final lista = gerarLista(itens: [itemConcluido]);

        final total = calcular.executar(lista);
        final esperado = (preco * quantidade).round();

        expect(total, equals(esperado),
            reason: 'Iteração $i: item concluído deve contribuir para o total');
      }
    });
  });
}
