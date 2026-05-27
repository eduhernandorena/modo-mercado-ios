'use strict';

import { describe, test, expect } from 'vitest';
import fc from 'fast-check';
import { getDashboardMetrics } from '../appController.js';

const produtoArb = fc.record({
  id: fc.uuid(),
  nome: fc.string({ minLength: 1, maxLength: 30 }),
  categoria: fc.constantFrom('Laticínios', 'Hortifruti', 'Limpeza'),
  unidade: fc.constantFrom('un', 'kg', 'L'),
  marca: fc.constant(null),
  observacao: fc.constant(null),
  criadoEm: fc.constant(new Date().toISOString()),
});

const mercadoArb = fc.record({
  id: fc.uuid(),
  nome: fc.string({ minLength: 1, maxLength: 30 }),
  criadoEm: fc.constant(new Date().toISOString()),
});

const registroArb = fc.record({
  id: fc.uuid(),
  produtoId: fc.uuid(),
  mercadoId: fc.uuid(),
  valor: fc.float({ min: Math.fround(0.01), max: Math.fround(100), noNaN: true }),
  data: fc.constant(new Date().toISOString()),
  criadoEm: fc.constant(new Date().toISOString()),
});

const appStateArb = fc.record({
  produtos: fc.array(produtoArb, { minLength: 0, maxLength: 15 }),
  mercados: fc.array(mercadoArb, { minLength: 0, maxLength: 10 }),
  registros: fc.array(registroArb, { minLength: 0, maxLength: 20 }),
});

// Feature: interactive-prototype, Property 9: Métricas do Dashboard refletem os dados simulados

describe('Property 9: Métricas do Dashboard refletem os dados simulados', () => {
  test(
    'contadores do card de resumo são iguais aos comprimentos dos arrays em appState',
    () => {
      fc.assert(
        fc.property(appStateArb, (partialState) => {
          const appState = {
            produtos: partialState.produtos,
            mercados: partialState.mercados,
            registros: partialState.registros,
          };

          const metrics = getDashboardMetrics(appState);

          expect(metrics.produtos).toBe(appState.produtos.length);
          expect(metrics.mercados).toBe(appState.mercados.length);
          expect(metrics.registros).toBe(appState.registros.length);
        }),
        { numRuns: 100 }
      );
    }
  );
});
