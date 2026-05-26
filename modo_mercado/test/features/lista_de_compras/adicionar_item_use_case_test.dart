// Feature: modo-mercado, Property 8: Restrição de produto sem preço na lista
// Valida: Requisitos 4.2, 4.3, 4.8

import 'package:flutter_test/flutter_test.dart';
import 'package:modo_mercado/core/domain/errors/app_error.dart';
import 'package:modo_mercado/features/lista_de_compras/domain/use_cases/adicionar_item_use_case.dart';
import '../../helpers/mock_repositories.dart';
import '../../helpers/test_factories.dart';

void main() {
  late InMemoryListaRepository listaRepo;
  late InMemoryRegistroRepository registroRepo;
  late AdicionarItemUseCase adicionar;

  setUp(() {
    listaRepo = InMemoryListaRepository();
    registroRepo = InMemoryRegistroRepository();
    adicionar = AdicionarItemUseCase(listaRepo, registroRepo);
  });

  group('Property 8: Restrição de produto sem preço na lista', () {
    test('Produto sem registros é rejeitado e lista permanece inalterada (100 iterações)',
        () async {
      // Feature: modo-mercado, Property 8: Restrição de produto sem preço na lista
      for (var i = 0; i < 100; i++) {
        registroRepo.clear();
        listaRepo.clear();

        final produto = gerarProduto(); // sem registros de preço
        final lista = gerarLista();
        await listaRepo.salvar(lista);

        final itensAntes = lista.itens.length;

        expect(
          () => adicionar.executar(
            lista: lista,
            produto: produto,
            quantidade: 1.0,
          ),
          throwsA(isA<ProdutoSemPrecoError>()),
          reason: 'Iteração $i: produto sem preço deveria ser rejeitado',
        );

        // Lista não deve ter sido alterada
        final listasAtuais = await listaRepo.listar();
        final listaAtual = listasAtuais.firstWhere((l) => l.id == lista.id);
        expect(listaAtual.itens.length, equals(itensAntes),
            reason: 'Iteração $i: lista não deve ser alterada após rejeição');
      }
    });

    test('Produto com registro é aceito e item é adicionado (100 iterações)', () async {
      // Feature: modo-mercado, Property 8: Restrição de produto sem preço na lista
      for (var i = 0; i < 100; i++) {
        registroRepo.clear();
        listaRepo.clear();

        final produto = gerarProduto();
        final mercado = gerarMercado();
        final registro = gerarRegistro(
          produtoId: produto.id,
          mercadoId: mercado.id,
        );
        registroRepo.addAll([registro]);

        final lista = gerarLista();
        await listaRepo.salvar(lista);

        final listaAtualizada = await adicionar.executar(
          lista: lista,
          produto: produto,
          quantidade: 2.0,
        );

        expect(listaAtualizada.itens.length, equals(lista.itens.length + 1),
            reason: 'Iteração $i: item deveria ter sido adicionado');
        expect(
          listaAtualizada.itens.last.ultimoPrecoRegistradoCentavos,
          equals(registro.valorCentavos),
          reason: 'Iteração $i: último preço deve ser capturado no momento da adição',
        );
      }
    });
  });
}
