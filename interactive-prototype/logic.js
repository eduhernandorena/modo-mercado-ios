/**
 * logic.js — Funções puras de lógica de negócio do protótipo ModoMercado.
 *
 * Este arquivo exporta as mesmas funções definidas inline no index.html,
 * permitindo que sejam importadas por testes (Vitest + fast-check) sem
 * depender do ambiente de browser.
 *
 * Exportações via CommonJS (module.exports) para compatibilidade com Vitest
 * em modo CJS ou com require() direto nos testes.
 */

'use strict';

/**
 * Calcula o subtotal de um item de lista.
 * Retorna ultimoPrecoRegistrado × quantidade, ou null se preço for nulo.
 * @param {{ ultimoPrecoRegistrado: number|null, quantidade: number }} item
 * @returns {number|null}
 */
function calcSubtotal(item) {
  if (item.ultimoPrecoRegistrado === null || item.ultimoPrecoRegistrado === undefined) {
    return null;
  }
  return item.ultimoPrecoRegistrado * item.quantidade;
}

/**
 * Calcula o total estimado de uma lista somando os subtotais não-nulos.
 * Itens sem preço registrado são ignorados (não afetam o total).
 * @param {Array<{ ultimoPrecoRegistrado: number|null, quantidade: number }>} itens
 * @returns {number}
 */
function calcTotalLista(itens) {
  return itens.reduce((acc, item) => {
    const sub = calcSubtotal(item);
    return sub !== null ? acc + sub : acc;
  }, 0);
}

/**
 * Ordena um array de registros de preço por data em ordem decrescente.
 * Não muta o array original.
 * @param {Array<{ data: string }>} registros
 * @returns {Array<{ data: string }>}
 */
function sortRegistrosByDateDesc(registros) {
  return [...registros].sort((a, b) => new Date(b.data) - new Date(a.data));
}

/**
 * Retorna o registro mais recente para um par produto+mercado específico.
 * @param {Array<{ produtoId: string, mercadoId: string, data: string }>} registros
 * @param {string} produtoId
 * @param {string} mercadoId
 * @returns {Object|null}
 */
function getUltimoRegistro(registros, produtoId, mercadoId) {
  const filtrados = registros.filter(
    r => r.produtoId === produtoId && r.mercadoId === mercadoId
  );
  if (filtrados.length === 0) return null;
  return sortRegistrosByDateDesc(filtrados)[0];
}

/**
 * Retorna o nome de um produto pelo seu ID.
 * @param {Array<{ id: string, nome: string }>} produtos
 * @param {string} id
 * @returns {string}
 */
function getNomeProduto(produtos, id) {
  const produto = produtos.find(p => p.id === id);
  return produto ? produto.nome : '(desconhecido)';
}

/**
 * Retorna o nome de um mercado pelo seu ID.
 * @param {Array<{ id: string, nome: string }>} mercados
 * @param {string} id
 * @returns {string}
 */
function getNomeMercado(mercados, id) {
  const mercado = mercados.find(m => m.id === id);
  return mercado ? mercado.nome : '(desconhecido)';
}

/**
 * Agrupa produtos por categoria.
 * Retorna um objeto Record<string, Produto[]> com chaves ordenadas alfabeticamente.
 * @param {Array<{ categoria: string }>} produtos
 * @returns {Object}
 */
function groupProdutosByCategoria(produtos) {
  const grupos = {};
  for (const produto of produtos) {
    const cat = produto.categoria;
    if (!grupos[cat]) grupos[cat] = [];
    grupos[cat].push(produto);
  }
  // Recriar objeto com chaves ordenadas alfabeticamente
  const chaves = Object.keys(grupos).sort((a, b) => a.localeCompare(b, 'pt-BR'));
  const resultado = {};
  for (const chave of chaves) {
    resultado[chave] = grupos[chave];
  }
  return resultado;
}

/**
 * Retorna dados de comparação de preços para um produto em todos os mercados.
 * Para cada mercado que possui pelo menos um registro do produto, retorna
 * o mercado e seu último registro. O array é ordenado por valor crescente.
 * @param {Array<{ produtoId: string, mercadoId: string, valor: number, data: string }>} registros
 * @param {string} produtoId
 * @param {Array<{ id: string, nome: string }>} mercados
 * @returns {Array<{ mercado: Object, ultimoRegistro: Object }>}
 */
function getComparacaoData(registros, produtoId, mercados) {
  const resultado = [];
  for (const mercado of mercados) {
    const ultimo = getUltimoRegistro(registros, produtoId, mercado.id);
    if (ultimo !== null) {
      resultado.push({ mercado, ultimoRegistro: ultimo });
    }
  }
  return resultado.sort((a, b) => a.ultimoRegistro.valor - b.ultimoRegistro.valor);
}

/**
 * Formata um número como moeda BRL (Real Brasileiro).
 * @param {number} valor
 * @returns {string} ex: "R$ 5,49"
 */
function formatBRL(valor) {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(valor);
}

/**
 * Formata uma string ISO 8601 como data no formato pt-BR.
 * @param {string} isoString
 * @returns {string} ex: "02/07/2025"
 */
function formatData(isoString) {
  return new Date(isoString).toLocaleDateString('pt-BR');
}

export {
  calcSubtotal,
  calcTotalLista,
  sortRegistrosByDateDesc,
  getUltimoRegistro,
  getNomeProduto,
  getNomeMercado,
  groupProdutosByCategoria,
  getComparacaoData,
  formatBRL,
  formatData,
};
