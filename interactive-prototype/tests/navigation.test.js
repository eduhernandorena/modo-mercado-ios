'use strict';

import { describe, test, expect } from 'vitest';
import fc from 'fast-check';
import { applyTabNavigation, TAB_NAMES } from '../appController.js';

const tabArb = fc.constantFrom(...TAB_NAMES);

// Feature: interactive-prototype, Property 1: Navegação por abas é mutuamente exclusiva

describe('Property 1: Navegação por abas é mutuamente exclusiva', () => {
  test(
    'após qualquer sequência de cliques, exatamente uma aba está ativa e activeListaId é null',
    () => {
      fc.assert(
        fc.property(
          fc.array(tabArb, { minLength: 1, maxLength: 30 }),
          (clicks) => {
            const appState = { activeTab: 'produtos', activeListaId: null };

            for (const tab of clicks) {
              applyTabNavigation(appState, tab);
            }

            expect(TAB_NAMES).toContain(appState.activeTab);
            expect(appState.activeListaId).toBeNull();
            expect(TAB_NAMES.filter((t) => t === appState.activeTab)).toHaveLength(1);
          }
        ),
        { numRuns: 100 }
      );
    }
  );

  test(
    'a aba ativa após a sequência é sempre a última clicada',
    () => {
      fc.assert(
        fc.property(
          fc.array(tabArb, { minLength: 1, maxLength: 30 }),
          (clicks) => {
            const appState = { activeTab: 'produtos', activeListaId: 'l1' };

            for (const tab of clicks) {
              applyTabNavigation(appState, tab);
            }

            expect(appState.activeTab).toBe(clicks[clicks.length - 1]);
          }
        ),
        { numRuns: 100 }
      );
    }
  );
});
