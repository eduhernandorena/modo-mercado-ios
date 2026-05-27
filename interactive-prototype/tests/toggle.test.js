'use strict';

import { describe, test, expect } from 'vitest';
import fc from 'fast-check';
import { toggleItemConcluido } from '../appController.js';

const itemArb = fc.record({
  id: fc.uuid(),
  produtoId: fc.uuid(),
  quantidade: fc.integer({ min: 1, max: 10 }),
  concluido: fc.boolean(),
  ultimoPrecoRegistrado: fc.option(
    fc.float({ min: Math.fround(0.01), max: Math.fround(50), noNaN: true }).map((v) => Math.round(v * 100) / 100),
    { nil: null }
  ),
});

const listaArb = fc
  .tuple(fc.uuid(), fc.string({ minLength: 1, maxLength: 40 }), fc.array(itemArb, { minLength: 1, maxLength: 8 }))
  .map(([id, nome, itens]) => ({
    id,
    nome,
    ativa: true,
    criadoEm: new Date().toISOString(),
    itens,
  }));

// Feature: interactive-prototype, Property 8: Toggle de checkbox preserva estado em memória

describe('Property 8: Toggle de checkbox preserva estado em memória', () => {
  test(
    'toggle alterna concluido e segunda alternância restaura o valor original',
    () => {
      fc.assert(
        fc.property(listaArb, fc.integer({ min: 0, max: 7 }), (lista, itemIdx) => {
          const appState = { listas: [JSON.parse(JSON.stringify(lista))] };
          const item = appState.listas[0].itens[itemIdx % appState.listas[0].itens.length];
          const original = item.concluido;

          const afterFirst = toggleItemConcluido(appState, lista.id, item.id);
          expect(afterFirst).toBe(!original);
          expect(item.concluido).toBe(!original);

          const afterSecond = toggleItemConcluido(appState, lista.id, item.id);
          expect(afterSecond).toBe(original);
          expect(item.concluido).toBe(original);
        }),
        { numRuns: 100 }
      );
    }
  );
});
