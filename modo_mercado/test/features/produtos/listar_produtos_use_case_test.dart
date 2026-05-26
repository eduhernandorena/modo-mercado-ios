// Feature: modo-mercado, Property 9: Ordenação alfabética da lista de produtos
// Feature: modo-mercado, Property 10: Filtragem de produtos por busca
// Valida: Requisitos 1.7, 1.8

import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/features/produtos/domain/use_cases/listar_produtos_use_case.dart';
import '../../helpers/mock_repositories.dart';
import '../../helpers/test_factories.dart';

void main() {
  late InMemoryProdutoRepository repo;
  late ListarProdutosUseCase listar;
  final random = Random();
  final faker = Faker();

  setUp(() {
    repo = InMemoryProdutoRepository();
    listar = ListarProdutosUseCase(repo);
  });

  group('Property 9: Ordenação alfabética da lista de produtos', () {
    test('Lista sempre ordenada lexicograficamente case-insensitive (100 iterações)', () async {
      // Feature: modo-mercado, Property 9: Ordenação alfabética da lista de produtos
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final n = random.nextInt(20) + 2;
        final produtos = gerarProdutos(n);
        for (final p in produtos) {
          await repo.salvar(p);
        }

        final resultado = await listar.executar();

        for (var j = 0; j < resultado.length - 1; j++) {
          final a = resultado[j].nome.toLowerCase();
          final b = resultado[j + 1].nome.toLowerCase();
          expect(a.compareTo(b) <= 0, isTrue,
              reason: 'Iteração $i: "$a" deveria vir antes de "$b"');
        }
      }
    });
  });

  group('Property 10: Filtragem de produtos por busca', () {
    test('Todos os retornados contêm o termo; nenhum fora do critério aparece (100 iterações)',
        () async {
      // Feature: modo-mercado, Property 10: Filtragem de produtos por busca
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final n = random.nextInt(15) + 5;
        final produtos = gerarProdutos(n);
        for (final p in produtos) {
          await repo.salvar(p);
        }

        // Termo de busca: substring aleatória de uma palavra do nome (sem espaços)
        final produtoAlvo = produtos[random.nextInt(produtos.length)];
        // Pegar uma palavra do nome (sem espaços) para garantir que o termo é válido
        final palavras = produtoAlvo.nome.split(' ').where((w) => w.length >= 2).toList();
        if (palavras.isEmpty) continue;
        final palavra = palavras[random.nextInt(palavras.length)];
        final inicio = random.nextInt(palavra.length - 1);
        final fim = inicio + random.nextInt(palavra.length - inicio) + 1;
        final termo = palavra.substring(inicio, fim).trim();

        if (termo.isEmpty) continue;

        final resultado = await listar.executar(termoBusca: termo);

        // Todos os retornados devem conter o termo
        for (final p in resultado) {
          final contemNome = p.nome.toLowerCase().contains(termo.toLowerCase());
          final contemCategoria =
              p.categoria.toLowerCase().contains(termo.toLowerCase());
          expect(contemNome || contemCategoria, isTrue,
              reason:
                  'Iteração $i: produto "${p.nome}" não contém o termo "$termo"');
        }

        // O produto alvo deve estar nos resultados (pois o termo vem do seu nome)
        final ids = resultado.map((p) => p.id).toSet();
        expect(ids.contains(produtoAlvo.id), isTrue,
            reason:
                'Iteração $i: produto alvo "${produtoAlvo.nome}" deveria aparecer para termo "$termo"');
      }
    });

    test('Busca com termo aleatório retorna apenas produtos que satisfazem o critério (100 iterações)',
        () async {
      // Feature: modo-mercado, Property 10: Filtragem de produtos por busca
      for (var i = 0; i < 100; i++) {
        repo.clear();
        final n = random.nextInt(20) + 5;
        final produtos = gerarProdutos(n);
        for (final p in produtos) {
          await repo.salvar(p);
        }

        final termo = faker.lorem.word();
        final resultado = await listar.executar(termoBusca: termo);

        for (final p in resultado) {
          final contemNome = p.nome.toLowerCase().contains(termo.toLowerCase());
          final contemCategoria =
              p.categoria.toLowerCase().contains(termo.toLowerCase());
          expect(contemNome || contemCategoria, isTrue,
              reason:
                  'Iteração $i: produto "${p.nome}" não satisfaz o critério para "$termo"');
        }
      }
    });
  });
}
