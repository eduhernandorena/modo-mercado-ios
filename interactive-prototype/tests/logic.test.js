'use strict';

import { describe, test, expect } from 'vitest';
import fc from 'fast-check';
import {
  calcSubtotal,
  calcTotalLista,
  sortRegistrosByDateDesc,
  getNomeProduto,
  getNomeMercado,
  getComparacaoData,
} from '../logic.js';

// ---------------------------------------------------------------------------
// Arbitraries
// ---------------------------------------------------------------------------

/**
 * Gera um ItemDeLista com ultimoPrecoRegistrado não nulo.
 * Preço: float positivo com até 2 casas decimais (R$ 0,01 – R$ 9999,99).
 * Quantidade: inteiro positivo (1–99).
 */
const itemComPreco = fc.record({
  id: fc.uuid(),
  produtoId: fc.uuid(),
  quantidade: fc.integer({ min: 1, max: 99 }),
  concluido: fc.boolean(),
  ultimoPrecoRegistrado: fc.float({ min: Math.fround(0.01), max: Math.fround(9999.99), noNaN: true }).map(
    (v) => Math.round(v * 100) / 100
  ),
});

/**
 * Gera um ItemDeLista com ultimoPrecoRegistrado nulo.
 */
const itemSemPreco = fc.record({
  id: fc.uuid(),
  produtoId: fc.uuid(),
  quantidade: fc.integer({ min: 1, max: 99 }),
  concluido: fc.boolean(),
  ultimoPrecoRegistrado: fc.constant(null),
});

/**
 * Gera um array de ItemDeLista com mistura de itens com e sem preço.
 */
const listaDeItens = fc.array(fc.oneof(itemComPreco, itemSemPreco), {
  minLength: 0,
  maxLength: 20,
});

// ---------------------------------------------------------------------------
// Property 4: Cálculo de subtotal de item
// ---------------------------------------------------------------------------
// Feature: interactive-prototype, Property 4: Cálculo de subtotal de item

describe('Property 4: Cálculo de subtotal de item', () => {
  test(
    'calcSubtotal retorna ultimoPrecoRegistrado × quantidade para itens com preço',
    () => {
      fc.assert(
        fc.property(itemComPreco, (item) => {
          const resultado = calcSubtotal(item);
          const esperado = item.ultimoPrecoRegistrado * item.quantidade;
          expect(resultado).toBeCloseTo(esperado, 10);
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'calcSubtotal retorna null para itens sem ultimoPrecoRegistrado',
    () => {
      fc.assert(
        fc.property(itemSemPreco, (item) => {
          const resultado = calcSubtotal(item);
          expect(resultado).toBeNull();
        }),
        { numRuns: 100 }
      );
    }
  );
});

// ---------------------------------------------------------------------------
// Property 5: Total estimado da lista é soma dos subtotais
// ---------------------------------------------------------------------------
// Feature: interactive-prototype, Property 5: Total estimado da lista é soma dos subtotais

describe('Property 5: Total estimado da lista é soma dos subtotais', () => {
  test(
    'calcTotalLista é igual à soma de ultimoPrecoRegistrado × quantidade dos itens com preço',
    () => {
      fc.assert(
        fc.property(listaDeItens, (itens) => {
          const total = calcTotalLista(itens);

          // Soma manual apenas dos itens com preço não nulo
          const somaEsperada = itens.reduce((acc, item) => {
            if (item.ultimoPrecoRegistrado !== null) {
              return acc + item.ultimoPrecoRegistrado * item.quantidade;
            }
            return acc;
          }, 0);

          expect(total).toBeCloseTo(somaEsperada, 10);
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'calcTotalLista ignora o estado concluido dos itens',
    () => {
      fc.assert(
        fc.property(
          fc.array(itemComPreco, { minLength: 1, maxLength: 10 }),
          (itens) => {
            // Calcula total com os itens originais
            const totalOriginal = calcTotalLista(itens);

            // Inverte o estado concluido de todos os itens
            const itensInvertidos = itens.map((item) => ({
              ...item,
              concluido: !item.concluido,
            }));
            const totalInvertido = calcTotalLista(itensInvertidos);

            expect(totalOriginal).toBeCloseTo(totalInvertido, 10);
          }
        ),
        { numRuns: 100 }
      );
    }
  );

  test(
    'calcTotalLista retorna 0 para lista vazia',
    () => {
      expect(calcTotalLista([])).toBe(0);
    }
  );

  test(
    'calcTotalLista retorna 0 quando todos os itens têm preço nulo',
    () => {
      fc.assert(
        fc.property(
          fc.array(itemSemPreco, { minLength: 1, maxLength: 10 }),
          (itens) => {
            expect(calcTotalLista(itens)).toBe(0);
          }
        ),
        { numRuns: 100 }
      );
    }
  );
});

// ---------------------------------------------------------------------------
// Arbitraries for RegistroDePreco
// ---------------------------------------------------------------------------

/**
 * Gera uma data ISO 8601 aleatória dentro de um intervalo de 365 dias.
 * Usamos timestamps inteiros para garantir comparações exatas.
 */
const isoDate = fc
  .integer({ min: 0, max: 365 * 24 * 60 * 60 * 1000 })
  .map((offsetMs) => new Date(Date.now() - offsetMs).toISOString());

/**
 * Gera um RegistroDePreco com campos mínimos necessários para os testes.
 */
const registroDePreco = fc.record({
  id: fc.uuid(),
  produtoId: fc.uuid(),
  mercadoId: fc.uuid(),
  valor: fc.float({ min: Math.fround(0.01), max: Math.fround(9999.99), noNaN: true }).map(
    (v) => Math.round(v * 100) / 100
  ),
  data: isoDate,
  criadoEm: isoDate,
});

/**
 * Gera um array de RegistroDePreco (pode ser vazio).
 */
const listaDeRegistros = fc.array(registroDePreco, {
  minLength: 0,
  maxLength: 20,
});

// ---------------------------------------------------------------------------
// Property 3: Ordenação de registros por data
// ---------------------------------------------------------------------------
// Feature: interactive-prototype, Property 3: Ordenação de registros por data

describe('Property 3: Ordenação de registros por data', () => {
  test(
    'sortRegistrosByDateDesc: para todo par adjacente (i, i+1), data[i] >= data[i+1]',
    () => {
      fc.assert(
        fc.property(listaDeRegistros, (registros) => {
          const ordenados = sortRegistrosByDateDesc(registros);

          for (let i = 0; i < ordenados.length - 1; i++) {
            const dataI = new Date(ordenados[i].data).getTime();
            const dataNext = new Date(ordenados[i + 1].data).getTime();
            expect(dataI).toBeGreaterThanOrEqual(dataNext);
          }
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'sortRegistrosByDateDesc não muta o array original',
    () => {
      fc.assert(
        fc.property(listaDeRegistros, (registros) => {
          const copia = [...registros];
          sortRegistrosByDateDesc(registros);
          // O array original deve permanecer inalterado
          expect(registros).toEqual(copia);
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'sortRegistrosByDateDesc retorna array com o mesmo número de elementos',
    () => {
      fc.assert(
        fc.property(listaDeRegistros, (registros) => {
          const ordenados = sortRegistrosByDateDesc(registros);
          expect(ordenados.length).toBe(registros.length);
        }),
        { numRuns: 100 }
      );
    }
  );
});

// ---------------------------------------------------------------------------
// Arbitraries for getComparacaoData
// ---------------------------------------------------------------------------

/**
 * Gera um Mercado com id e nome únicos.
 */
const mercadoArb = fc.record({
  id: fc.uuid(),
  nome: fc.string({ minLength: 1, maxLength: 50 }),
});

/**
 * Gera um RegistroDePreco com valor positivo e data ISO 8601 válida.
 * O produtoId e mercadoId são injetados externamente para garantir consistência.
 */
const registroArb = (produtoId, mercadoId) =>
  fc.record({
    id: fc.uuid(),
    produtoId: fc.constant(produtoId),
    mercadoId: fc.constant(mercadoId),
    valor: fc.float({ min: Math.fround(0.01), max: Math.fround(9999.99), noNaN: true }).map(
      (v) => Math.round(v * 100) / 100
    ),
    data: fc
      .integer({ min: 0, max: 29 })
      .map((daysAgo) => new Date(Date.now() - daysAgo * 86400000).toISOString()),
    criadoEm: fc.constant(new Date().toISOString()),
  });

/**
 * Gera um cenário completo para getComparacaoData:
 * - Um produtoId fixo
 * - Um array de mercados (1–5)
 * - Para cada mercado, 1–3 registros do produto (garantindo que todos têm dados)
 * - Opcionalmente, registros de outros produtos (ruído)
 */
const comparacaoScenario = fc
  .tuple(
    fc.uuid(), // produtoId
    fc.array(mercadoArb, { minLength: 1, maxLength: 5 }),
  )
  .chain(([produtoId, mercados]) => {
    // Para cada mercado, gera 1–3 registros do produto alvo
    const registrosPorMercado = mercados.map((mercado) =>
      fc.array(registroArb(produtoId, mercado.id), { minLength: 1, maxLength: 3 })
    );

    return fc.tuple(...registrosPorMercado).map((registrosArrays) => {
      const registros = registrosArrays.flat();
      return { produtoId, mercados, registros };
    });
  });

/**
 * Cenário onde nenhum mercado tem registro para o produto selecionado.
 */
const comparacaoVaziaScenario = fc.tuple(
  fc.uuid(), // produtoId sem registros
  fc.array(mercadoArb, { minLength: 0, maxLength: 5 }),
  fc.uuid(), // outro produtoId com registros (ruído)
).chain(([produtoId, mercados, outroProdutoId]) => {
  const registrosOutroProduto = mercados.length > 0
    ? fc.array(registroArb(outroProdutoId, mercados[0]?.id ?? fc.uuid()), { minLength: 0, maxLength: 3 })
    : fc.constant([]);
  return registrosOutroProduto.map((registros) => ({ produtoId, mercados, registros }));
});

// ---------------------------------------------------------------------------
// Property 6: Comparação ordena por valor crescente
// ---------------------------------------------------------------------------
// Feature: interactive-prototype, Property 6: Comparação ordena por valor crescente

describe('Property 6: Comparação ordena por valor crescente', () => {
  test(
    'getComparacaoData retorna mercados ordenados por valor crescente (par adjacente i <= i+1)',
    () => {
      fc.assert(
        fc.property(comparacaoScenario, ({ produtoId, mercados, registros }) => {
          const resultado = getComparacaoData(registros, produtoId, mercados);

          // Para todo par adjacente (i, i+1), valor[i] <= valor[i+1]
          for (let i = 0; i < resultado.length - 1; i++) {
            const valorAtual = resultado[i].ultimoRegistro.valor;
            const valorProximo = resultado[i + 1].ultimoRegistro.valor;
            expect(valorAtual).toBeLessThanOrEqual(valorProximo);
          }
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'getComparacaoData retorna array vazio quando não há registros para o produto',
    () => {
      fc.assert(
        fc.property(comparacaoVaziaScenario, ({ produtoId, mercados, registros }) => {
          const resultado = getComparacaoData(registros, produtoId, mercados);
          expect(resultado).toHaveLength(0);
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'getComparacaoData retorna exatamente um item por mercado que possui registro',
    () => {
      fc.assert(
        fc.property(comparacaoScenario, ({ produtoId, mercados, registros }) => {
          const resultado = getComparacaoData(registros, produtoId, mercados);

          // Todos os mercados do cenário têm pelo menos um registro, então
          // o resultado deve ter exatamente mercados.length itens
          expect(resultado).toHaveLength(mercados.length);

          // Cada mercado aparece exatamente uma vez
          const mercadoIds = resultado.map((r) => r.mercado.id);
          const mercadoIdsUnicos = new Set(mercadoIds);
          expect(mercadoIdsUnicos.size).toBe(mercados.length);
        }),
        { numRuns: 100 }
      );
    }
  );
});

// ---------------------------------------------------------------------------
// Property 7: Badge "Melhor preço" identifica o mínimo
// ---------------------------------------------------------------------------
// Feature: interactive-prototype, Property 7: Badge "Melhor preço" identifica o mínimo

describe('Property 7: Badge "Melhor preço" identifica o mínimo', () => {
  test(
    'o primeiro item do resultado (índice 0) tem o menor valor entre todos os mercados',
    () => {
      fc.assert(
        fc.property(comparacaoScenario, ({ produtoId, mercados, registros }) => {
          const resultado = getComparacaoData(registros, produtoId, mercados);

          // O cenário garante pelo menos 1 mercado com registro
          expect(resultado.length).toBeGreaterThanOrEqual(1);

          const valorMinimo = resultado[0].ultimoRegistro.valor;

          // Nenhum outro item deve ter valor menor que o primeiro
          for (let i = 1; i < resultado.length; i++) {
            expect(resultado[i].ultimoRegistro.valor).toBeGreaterThanOrEqual(valorMinimo);
          }
        }),
        { numRuns: 100 }
      );
    }
  );

  test(
    'o valor do primeiro item é igual ao mínimo calculado independentemente',
    () => {
      fc.assert(
        fc.property(comparacaoScenario, ({ produtoId, mercados, registros }) => {
          const resultado = getComparacaoData(registros, produtoId, mercados);

          // Calcula o mínimo de forma independente: para cada mercado, pega o
          // último registro e extrai o menor valor
          const valoresMinimoPorMercado = mercados.map((mercado) => {
            const registrosMercado = registros
              .filter((r) => r.produtoId === produtoId && r.mercadoId === mercado.id)
              .sort((a, b) => new Date(b.data) - new Date(a.data));
            return registrosMercado.length > 0 ? registrosMercado[0].valor : Infinity;
          }).filter((v) => v !== Infinity);

          const minimoEsperado = Math.min(...valoresMinimoPorMercado);

          expect(resultado[0].ultimoRegistro.valor).toBe(minimoEsperado);
        }),
        { numRuns: 100 }
      );
    }
  );
});

// ---------------------------------------------------------------------------
// Arbitraries for Produto and Mercado
// ---------------------------------------------------------------------------

/**
 * Gera um nome não-vazio (string de 1–50 caracteres alfanuméricos/espaços).
 */
const nomeNaoVazio = fc.stringOf(
  fc.char().filter((c) => /[\w\s]/.test(c)),
  { minLength: 1, maxLength: 50 }
);

/**
 * Gera um Produto com id e nome.
 */
const produto = fc.record({
  id: fc.uuid(),
  nome: nomeNaoVazio,
  categoria: nomeNaoVazio,
  unidade: fc.constantFrom('un', 'kg', 'L', 'g', 'ml'),
  marca: fc.option(nomeNaoVazio, { nil: null }),
  observacao: fc.option(nomeNaoVazio, { nil: null }),
  criadoEm: fc.constant(new Date().toISOString()),
});

/**
 * Gera um Mercado com id e nome.
 */
const mercado = fc.record({
  id: fc.uuid(),
  nome: nomeNaoVazio,
  criadoEm: fc.constant(new Date().toISOString()),
});

/**
 * Gera um array não-vazio de Produtos (sem IDs duplicados).
 */
const listaDeProdutos = fc
  .array(produto, { minLength: 1, maxLength: 10 })
  .filter((ps) => new Set(ps.map((p) => p.id)).size === ps.length);

/**
 * Gera um array não-vazio de Mercados (sem IDs duplicados).
 */
const listaDeMercados = fc
  .array(mercado, { minLength: 1, maxLength: 10 })
  .filter((ms) => new Set(ms.map((m) => m.id)).size === ms.length);

// ---------------------------------------------------------------------------
// Property 2: Resolução de nomes via ID é consistente
// ---------------------------------------------------------------------------
// Feature: interactive-prototype, Property 2: Resolução de nomes via ID é consistente

describe('Property 2: Resolução de nomes via ID é consistente', () => {
  // getNomeProduto — ID existente retorna o nome correto
  test(
    'getNomeProduto retorna o nome do produto cujo id corresponde ao buscado',
    () => {
      fc.assert(
        fc.property(
          listaDeProdutos,
          fc.integer({ min: 0, max: 9 }),
          (produtos, idx) => {
            const alvo = produtos[idx % produtos.length];
            const resultado = getNomeProduto(produtos, alvo.id);
            expect(resultado).toBe(alvo.nome);
          }
        ),
        { numRuns: 100 }
      );
    }
  );

  // getNomeProduto — ID desconhecido retorna "(desconhecido)"
  test(
    'getNomeProduto retorna "(desconhecido)" para ID não presente na lista',
    () => {
      fc.assert(
        fc.property(
          listaDeProdutos,
          fc.uuid(),
          (produtos, idDesconhecido) => {
            // Garantir que o ID gerado não coincide com nenhum produto da lista
            fc.pre(!produtos.some((p) => p.id === idDesconhecido));
            const resultado = getNomeProduto(produtos, idDesconhecido);
            expect(resultado).toBe('(desconhecido)');
          }
        ),
        { numRuns: 100 }
      );
    }
  );

  // getNomeProduto — lista vazia sempre retorna "(desconhecido)"
  test(
    'getNomeProduto retorna "(desconhecido)" quando a lista de produtos está vazia',
    () => {
      fc.assert(
        fc.property(fc.uuid(), (id) => {
          expect(getNomeProduto([], id)).toBe('(desconhecido)');
        }),
        { numRuns: 100 }
      );
    }
  );

  // getNomeMercado — ID existente retorna o nome correto
  test(
    'getNomeMercado retorna o nome do mercado cujo id corresponde ao buscado',
    () => {
      fc.assert(
        fc.property(
          listaDeMercados,
          fc.integer({ min: 0, max: 9 }),
          (mercados, idx) => {
            const alvo = mercados[idx % mercados.length];
            const resultado = getNomeMercado(mercados, alvo.id);
            expect(resultado).toBe(alvo.nome);
          }
        ),
        { numRuns: 100 }
      );
    }
  );

  // getNomeMercado — ID desconhecido retorna "(desconhecido)"
  test(
    'getNomeMercado retorna "(desconhecido)" para ID não presente na lista',
    () => {
      fc.assert(
        fc.property(
          listaDeMercados,
          fc.uuid(),
          (mercados, idDesconhecido) => {
            fc.pre(!mercados.some((m) => m.id === idDesconhecido));
            const resultado = getNomeMercado(mercados, idDesconhecido);
            expect(resultado).toBe('(desconhecido)');
          }
        ),
        { numRuns: 100 }
      );
    }
  );

  // getNomeMercado — lista vazia sempre retorna "(desconhecido)"
  test(
    'getNomeMercado retorna "(desconhecido)" quando a lista de mercados está vazia',
    () => {
      fc.assert(
        fc.property(fc.uuid(), (id) => {
          expect(getNomeMercado([], id)).toBe('(desconhecido)');
        }),
        { numRuns: 100 }
      );
    }
  );

  // Consistência com dados simulados: para qualquer RegistroDePreco cujos IDs
  // existam nos arrays de produtos e mercados, os nomes resolvidos devem
  // corresponder exatamente aos nomes dos objetos referenciados.
  test(
    'para qualquer RegistroDePreco com IDs válidos, getNomeProduto e getNomeMercado retornam os nomes corretos',
    () => {
      fc.assert(
        fc.property(
          listaDeProdutos,
          listaDeMercados,
          fc.integer({ min: 0, max: 9 }),
          fc.integer({ min: 0, max: 9 }),
          (produtos, mercados, pIdx, mIdx) => {
            const produtoAlvo = produtos[pIdx % produtos.length];
            const mercadoAlvo = mercados[mIdx % mercados.length];

            // Simula um RegistroDePreco que referencia esses IDs
            const registro = {
              id: 'reg-1',
              produtoId: produtoAlvo.id,
              mercadoId: mercadoAlvo.id,
              valor: 5.99,
              data: new Date().toISOString(),
              criadoEm: new Date().toISOString(),
            };

            expect(getNomeProduto(produtos, registro.produtoId)).toBe(produtoAlvo.nome);
            expect(getNomeMercado(mercados, registro.mercadoId)).toBe(mercadoAlvo.nome);
          }
        ),
        { numRuns: 100 }
      );
    }
  );
});
