// Feature: modo-mercado, Property 4: Ordenação do histórico
// Feature: modo-mercado, Property 5: Corretude das métricas do histórico
// Feature: modo-mercado, Property 11: Filtragem do histórico por mercado e período
// Valida: Requisitos 3.1, 3.2, 3.3, 3.4, 3.6, 3.8, 3.9

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/features/historico/domain/use_cases/calcular_metricas_use_case.dart';
import 'package:uuid/uuid.dart';
import '../../helpers/mock_repositories.dart';
import '../../helpers/test_factories.dart';

void main() {
  late InMemoryRegistroRepository repo;
  late CalcularMetricasUseCase calcular;
  final random = Random();
  const uuid = Uuid();

  setUp(() {
    repo = InMemoryRegistroRepository();
    calcular = CalcularMetricasUseCase(repo);
  });

  group('Property 4: Ordenação do histórico', () {
    test('Registros sempre em ordem decrescente de data (100 iterações)', () async {
      // Feature: modo-mercado, Property 4: Ordenação do histórico
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final produtoId = uuid.v4();
        final mercadoId = uuid.v4();
        final n = random.nextInt(20) + 2;
        final registros = gerarRegistrosAleatorios(produtoId, mercadoId, n);
        repo.addAll(registros);

        final metricas = await calcular.executar(produtoId: produtoId);

        for (var j = 0; j < metricas.registros.length - 1; j++) {
          expect(
            metricas.registros[j].data.isAfter(metricas.registros[j + 1].data) ||
                metricas.registros[j].data.isAtSameMomentAs(metricas.registros[j + 1].data),
            isTrue,
            reason: 'Iteração $i: registro $j deveria ser >= registro ${j + 1}',
          );
        }
      }
    });
  });

  group('Property 5: Corretude das métricas do histórico', () {
    test('menorPreco <= mediaPreco <= maiorPreco e valores presentes no conjunto (100 iterações)',
        () async {
      // Feature: modo-mercado, Property 5: Corretude das métricas do histórico
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final produtoId = uuid.v4();
        final mercadoId = uuid.v4();
        final n = random.nextInt(20) + 1;
        final registros = gerarRegistrosAleatorios(produtoId, mercadoId, n);
        repo.addAll(registros);

        final metricas = await calcular.executar(produtoId: produtoId);

        expect(metricas.menorPrecoCentavos, isNotNull);
        expect(metricas.maiorPrecoCentavos, isNotNull);
        expect(metricas.mediaPrecoCentavos, isNotNull);

        final menor = metricas.menorPrecoCentavos!;
        final maior = metricas.maiorPrecoCentavos!;
        final media = metricas.mediaPrecoCentavos!;

        expect(menor <= media, isTrue,
            reason: 'Iteração $i: menor ($menor) deve ser <= media ($media)');
        expect(media <= maior, isTrue,
            reason: 'Iteração $i: media ($media) deve ser <= maior ($maior)');

        final valores = registros.map((r) => r.valorCentavos).toSet();
        expect(valores.contains(menor), isTrue,
            reason: 'Iteração $i: menor ($menor) deve estar no conjunto');
        expect(valores.contains(maior), isTrue,
            reason: 'Iteração $i: maior ($maior) deve estar no conjunto');
      }
    });
  });

  group('Property 11: Filtragem do histórico por mercado e período', () {
    test('Filtro por mercado retorna apenas registros do mercado (100 iterações)', () async {
      // Feature: modo-mercado, Property 11: Filtragem do histórico por mercado e período
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final produtoId = uuid.v4();
        final mercadoAlvo = uuid.v4();
        final mercadoOutro = uuid.v4();

        final registrosAlvo = gerarRegistrosAleatorios(produtoId, mercadoAlvo, random.nextInt(5) + 1);
        final registrosOutro = gerarRegistrosAleatorios(produtoId, mercadoOutro, random.nextInt(5) + 1);
        repo.addAll([...registrosAlvo, ...registrosOutro]);

        final metricas = await calcular.executar(
          produtoId: produtoId,
          filtroMercadoId: mercadoAlvo,
        );

        for (final r in metricas.registros) {
          expect(r.mercadoId, equals(mercadoAlvo),
              reason: 'Iteração $i: registro de mercado errado no resultado filtrado');
        }
        expect(metricas.registros.length, equals(registrosAlvo.length));
      }
    });

    test('Filtro por período retorna apenas registros dentro do intervalo (100 iterações)',
        () async {
      // Feature: modo-mercado, Property 11: Filtragem do histórico por mercado e período
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final produtoId = uuid.v4();
        final mercadoId = uuid.v4();

        final base = DateTime(2024, 1, 1);
        final inicio = base.add(Duration(days: random.nextInt(100)));
        final fim = inicio.add(Duration(days: random.nextInt(50) + 1));

        // Registros dentro do período
        final dentro = List.generate(
          random.nextInt(5) + 1,
          (_) => gerarRegistro(
            produtoId: produtoId,
            mercadoId: mercadoId,
            data: inicio.add(Duration(
              hours: random.nextInt(fim.difference(inicio).inHours),
            )),
          ),
        );
        // Registros fora do período
        final fora = List.generate(
          random.nextInt(5) + 1,
          (_) => gerarRegistro(
            produtoId: produtoId,
            mercadoId: mercadoId,
            data: base.subtract(Duration(days: random.nextInt(100) + 1)),
          ),
        );
        repo.addAll([...dentro, ...fora]);

        final metricas = await calcular.executar(
          produtoId: produtoId,
          periodoInicio: inicio,
          periodoFim: fim,
        );

        for (final r in metricas.registros) {
          expect(
            !r.data.isBefore(inicio) && !r.data.isAfter(fim),
            isTrue,
            reason: 'Iteração $i: registro fora do período no resultado filtrado',
          );
        }
      }
    });
  });
}
