// Feature: modo-mercado, Property 2: Validação de campos obrigatórios do Produto
// Valida: Requisitos 1.2, 1.3, 1.6

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/core/domain/errors/app_error.dart';
import 'package:modo_mercado/features/produtos/domain/use_cases/cadastrar_produto_use_case.dart';
import 'package:modo_mercado/features/produtos/domain/use_cases/editar_produto_use_case.dart';
import 'package:modo_mercado/core/domain/models/produto.dart';
import '../../helpers/mock_repositories.dart';
import '../../helpers/test_factories.dart';

void main() {
  late InMemoryProdutoRepository repo;
  late CadastrarProdutoUseCase cadastrar;
  late EditarProdutoUseCase editar;
  final random = Random();

  setUp(() {
    repo = InMemoryProdutoRepository();
    cadastrar = CadastrarProdutoUseCase(repo);
    editar = EditarProdutoUseCase(repo);
  });

  // Gera strings inválidas: vazia ou só espaços
  String gerarCampoInvalido() =>
      random.nextBool() ? '' : ' ' * (random.nextInt(5) + 1);

  group('Property 2: Validação de campos obrigatórios do Produto', () {
    test('CadastrarProduto rejeita nome ausente/em branco (100 iterações)', () async {
      // Feature: modo-mercado, Property 2: Validação de campos obrigatórios do Produto
      for (var i = 0; i < 100; i++) {
        final nomeInvalido = gerarCampoInvalido();
        final contaAntes = (await repo.listar()).length;

        expect(
          () => cadastrar.executar(
            nome: nomeInvalido,
            categoria: 'Categoria',
            unidade: 'un',
          ),
          throwsA(isA<CampoObrigatorioAusenteError>()),
          reason: 'Iteração $i: nome "$nomeInvalido" deveria ser rejeitado',
        );

        final contaDepois = (await repo.listar()).length;
        expect(contaDepois, equals(contaAntes),
            reason: 'Iteração $i: não deve persistir com nome inválido');
      }
    });

    test('CadastrarProduto rejeita categoria ausente/em branco (100 iterações)', () async {
      // Feature: modo-mercado, Property 2: Validação de campos obrigatórios do Produto
      for (var i = 0; i < 100; i++) {
        final categoriaInvalida = gerarCampoInvalido();
        final contaAntes = (await repo.listar()).length;

        expect(
          () => cadastrar.executar(
            nome: 'Produto Válido',
            categoria: categoriaInvalida,
            unidade: 'un',
          ),
          throwsA(isA<CampoObrigatorioAusenteError>()),
        );

        expect((await repo.listar()).length, equals(contaAntes));
      }
    });

    test('CadastrarProduto rejeita unidade ausente/em branco (100 iterações)', () async {
      // Feature: modo-mercado, Property 2: Validação de campos obrigatórios do Produto
      for (var i = 0; i < 100; i++) {
        final unidadeInvalida = gerarCampoInvalido();
        final contaAntes = (await repo.listar()).length;

        expect(
          () => cadastrar.executar(
            nome: 'Produto Válido',
            categoria: 'Categoria',
            unidade: unidadeInvalida,
          ),
          throwsA(isA<CampoObrigatorioAusenteError>()),
        );

        expect((await repo.listar()).length, equals(contaAntes));
      }
    });

    test('EditarProduto rejeita campos obrigatórios ausentes (100 iterações)', () async {
      // Feature: modo-mercado, Property 2: Validação de campos obrigatórios do Produto
      final base = gerarProduto();
      await repo.salvar(base);

      for (var i = 0; i < 100; i++) {
        final campo = random.nextInt(3);
        late Produto invalido;

        switch (campo) {
          case 0:
            invalido = base.copyWith(nome: gerarCampoInvalido());
          case 1:
            invalido = base.copyWith(categoria: gerarCampoInvalido());
          default:
            invalido = base.copyWith(unidade: gerarCampoInvalido());
        }

        expect(
          () => editar.executar(invalido),
          throwsA(isA<CampoObrigatorioAusenteError>()),
          reason: 'Iteração $i: campo $campo inválido deveria ser rejeitado',
        );
      }
    });
  });
}
