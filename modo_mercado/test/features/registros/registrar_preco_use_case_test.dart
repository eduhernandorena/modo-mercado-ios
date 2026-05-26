// Feature: modo-mercado, Property 3: Validação de valor positivo no Registro de Preço
// Valida: Requisitos 2.2, 2.3, 2.4

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/core/domain/errors/app_error.dart';
import 'package:modo_mercado/features/registros/domain/use_cases/registrar_preco_use_case.dart';
import '../../helpers/mock_repositories.dart';

void main() {
  late InMemoryRegistroRepository repo;
  late RegistrarPrecoUseCase registrar;
  final random = Random();

  setUp(() {
    repo = InMemoryRegistroRepository();
    registrar = RegistrarPrecoUseCase(repo);
  });

  group('Property 3: Validação de valor positivo no Registro de Preço', () {
    test('Rejeita valorCentavos <= 0 e não persiste (100 iterações)', () async {
      // Feature: modo-mercado, Property 3: Validação de valor positivo no Registro de Preço
      for (var i = 0; i < 100; i++) {
        // Gera valor inválido: 0 ou negativo
        final valorInvalido = random.nextBool() ? 0 : -(random.nextInt(10000) + 1);
        final contaAntes = (await repo.listarPorProduto('p1')).length;

        expect(
          () => registrar.executar(
            produtoId: 'produto-1',
            mercadoId: 'mercado-1',
            valorCentavos: valorInvalido,
            data: DateTime.now(),
          ),
          throwsA(isA<ValorInvalidoError>()),
          reason: 'Iteração $i: valor $valorInvalido deveria ser rejeitado',
        );

        final contaDepois = (await repo.listarPorProduto('p1')).length;
        expect(contaDepois, equals(contaAntes),
            reason: 'Iteração $i: não deve persistir com valor inválido');
      }
    });

    test('Rejeita produtoId vazio e não persiste (100 iterações)', () async {
      // Feature: modo-mercado, Property 3: Validação de valor positivo no Registro de Preço
      for (var i = 0; i < 100; i++) {
        final produtoIdInvalido = random.nextBool() ? '' : '   ';

        expect(
          () => registrar.executar(
            produtoId: produtoIdInvalido,
            mercadoId: 'mercado-1',
            valorCentavos: 1000,
            data: DateTime.now(),
          ),
          throwsA(isA<CampoObrigatorioAusenteError>()),
        );
      }
    });

    test('Rejeita mercadoId vazio e não persiste (100 iterações)', () async {
      // Feature: modo-mercado, Property 3: Validação de valor positivo no Registro de Preço
      for (var i = 0; i < 100; i++) {
        final mercadoIdInvalido = random.nextBool() ? '' : '   ';

        expect(
          () => registrar.executar(
            produtoId: 'produto-1',
            mercadoId: mercadoIdInvalido,
            valorCentavos: 1000,
            data: DateTime.now(),
          ),
          throwsA(isA<CampoObrigatorioAusenteError>()),
        );
      }
    });
  });
}
