// Feature: modo-mercado, Property 6: Corretude da comparação entre mercados
// Valida: Requisitos 6.1, 6.2, 6.3, 6.6

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/features/comparacao/domain/use_cases/comparar_mercados_use_case.dart';
import 'package:uuid/uuid.dart';
import '../../helpers/mock_repositories.dart';
import '../../helpers/test_factories.dart';

void main() {
  late InMemoryRegistroRepository registroRepo;
  late InMemoryMercadoRepository mercadoRepo;
  late CompararMercadosUseCase comparar;
  final random = Random();
  const uuid = Uuid();

  setUp(() {
    registroRepo = InMemoryRegistroRepository();
    mercadoRepo = InMemoryMercadoRepository();
    comparar = CompararMercadosUseCase(registroRepo, mercadoRepo);
  });

  group('Property 6: Corretude da comparação entre mercados', () {
    test(
        'N mercados → N itens, preço mais recente, ordenados menor→maior, exatamente 1 eMenorPreco (100 iterações)',
        () async {
      // Feature: modo-mercado, Property 6: Corretude da comparação entre mercados
      for (var i = 0; i < 100; i++) {
        registroRepo.clear();
        mercadoRepo.clear();

        final produtoId = uuid.v4();
        final n = random.nextInt(5) + 2; // 2 a 6 mercados
        final mercados = List.generate(n, (_) => gerarMercado());
        mercadoRepo.addAll(mercados);

        // Para cada mercado, adicionar 1-3 registros com datas diferentes
        for (final mercado in mercados) {
          final numRegistros = random.nextInt(3) + 1;
          final baseDate = DateTime(2024, 1, 1);
          for (var k = 0; k < numRegistros; k++) {
            registroRepo.addAll([
              gerarRegistro(
                produtoId: produtoId,
                mercadoId: mercado.id,
                data: baseDate.add(Duration(days: k)),
              ),
            ]);
          }
        }

        final resultado = await comparar.executar(produtoId);

        // Deve ter exatamente N itens
        expect(resultado.length, equals(n),
            reason: 'Iteração $i: esperado $n itens, obtido ${resultado.length}');

        // Deve estar ordenado do menor para o maior preço
        for (var j = 0; j < resultado.length - 1; j++) {
          expect(
            resultado[j].ultimoPrecoCentavos <= resultado[j + 1].ultimoPrecoCentavos,
            isTrue,
            reason: 'Iteração $i: lista não está ordenada por preço',
          );
        }

        // Exatamente um item com eMenorPreco = true
        final menores = resultado.where((c) => c.eMenorPreco).toList();
        expect(menores.length, equals(1),
            reason: 'Iteração $i: deve haver exatamente 1 item com eMenorPreco=true');

        // O item com eMenorPreco deve ser o primeiro (menor preço)
        expect(resultado.first.eMenorPreco, isTrue,
            reason: 'Iteração $i: o primeiro item deve ter eMenorPreco=true');

        // Cada item deve ter o preço do registro mais recente do mercado
        for (final comp in resultado) {
          final registrosMercado = await registroRepo.listarPorMercado(comp.mercado.id);
          final registrosDoProduto =
              registrosMercado.where((r) => r.produtoId == produtoId).toList()
                ..sort((a, b) => b.data.compareTo(a.data));
          expect(
            comp.ultimoPrecoCentavos,
            equals(registrosDoProduto.first.valorCentavos),
            reason: 'Iteração $i: preço do mercado ${comp.mercado.id} não é o mais recente',
          );
        }
      }
    });
  });
}
