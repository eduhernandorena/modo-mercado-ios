/**
 * appController.js — Funções de navegação e estado testáveis fora do browser.
 */

'use strict';

const TAB_NAMES = ['produtos', 'registros', 'listas', 'dashboard', 'comparacao'];

/**
 * Aplica navegação por aba, espelhando setActiveTab (sem efeitos de DOM).
 * @param {{ activeTab: string, activeListaId: string|null }} appState
 * @param {string} tabName
 * @returns {string} aba ativa após a navegação
 */
export function applyTabNavigation(appState, tabName) {
  appState.activeTab = tabName;
  appState.activeListaId = null;
  return appState.activeTab;
}

/**
 * Alterna o estado concluido de um item de lista em appState.
 * @param {{ listas: Array<{ id: string, itens: Array<{ id: string, concluido: boolean }> }> }} appState
 * @param {string} listaId
 * @param {string} itemId
 * @returns {boolean} novo valor de concluido
 */
export function toggleItemConcluido(appState, listaId, itemId) {
  const lista = appState.listas.find((l) => l.id === listaId);
  if (!lista) throw new Error(`Lista não encontrada: ${listaId}`);
  const item = lista.itens.find((i) => i.id === itemId);
  if (!item) throw new Error(`Item não encontrado: ${itemId}`);
  item.concluido = !item.concluido;
  return item.concluido;
}

/**
 * Retorna métricas do card de resumo do Dashboard.
 * @param {{ produtos: unknown[], mercados: unknown[], registros: unknown[] }} appState
 */
export function getDashboardMetrics(appState) {
  return {
    produtos: appState.produtos.length,
    mercados: appState.mercados.length,
    registros: appState.registros.length,
  };
}

export { TAB_NAMES };
