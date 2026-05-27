# Implementation Plan: Protótipo Interativo ModoMercado

## Overview

Implementar o protótipo interativo como um único arquivo `index.html` auto-contido em Vanilla JS, simulando a interface do app iOS ModoMercado com 5 telas navegáveis via TabBar. A implementação segue a arquitetura SPA manual com três camadas: Data Layer (mockData), State Layer (appState) e UI Layer (funções render*).

## Tasks

- [x] 1. Estrutura base do arquivo e CSS do Shell iOS
  - [x] 1.1 Criar o arquivo `index.html` com estrutura HTML base e CSS completo embutido
    - Criar o arquivo `index.html` na raiz do projeto (ou em `interactive-prototype/`)
    - Definir o `<head>` com meta viewport, charset e título "ModoMercado Protótipo"
    - Implementar o CSS do `#ios-shell` (390×844px, border-radius 44px, box-shadow)
    - Implementar responsividade: viewport ≥ 768px centraliza o shell com fundo `#E5E5EA`; viewport < 768px ocupa 100% da largura com border-radius 0
    - Implementar o `#status-bar` (44px de altura) com horário fixo "9:41" e ícones SVG de sinal, Wi-Fi e bateria
    - Implementar o `#screen-container` como área de conteúdo com scroll interno
    - Implementar o `#tab-bar` (83px: 78px de abas + 5px de home indicator) com cinco `.tab-item`
    - Aplicar a paleta de cores iOS: `#007AFF`, `#34C759`, `#F2F2F7`, `#FFFFFF`, `#C6C6C8`, `#000000`, `#8E8E93`
    - Aplicar font-stack: `-apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", system-ui`
    - Definir estilos tipográficos: título grande 700/34px, título de navegação 600/17px, corpo 400/17px, legenda 400/12px
    - _Requirements: 1.1, 1.2, 1.3, 8.1, 8.2, 8.3, 8.6_

  - [x] 1.2 Implementar CSS dos componentes reutilizáveis (NavBar, listas, modais)
    - Estilizar `.nav-bar` com título centralizado (600/17px) e botão de ação à direita
    - Estilizar listas iOS: separadores 1px `#C6C6C8`, fundo branco nos cards, fundo `#F2F2F7` na área geral
    - Estilizar `.modal-overlay` (fundo semi-transparente) e `.bottom-sheet` com `border-radius` no topo
    - Implementar animação CSS do bottom-sheet: `translateY(100%)` → `translateY(0)` em 300ms `ease-out`
    - Estilizar estado vazio (`.empty-state`) com ícone e texto centralizados
    - Estilizar checkbox de item de lista com estado concluído (texto riscado, opacidade 0.4)
    - _Requirements: 8.4, 8.5, 4.5_

- [x] 2. Camada de dados e estado da aplicação
  - [x] 2.1 Implementar `mockData` com todos os dados simulados
    - Definir array `mockData.produtos` com 8+ produtos em 3+ categorias ("Laticínios", "Hortifruti", "Limpeza"), cada um com `id`, `nome`, `categoria`, `unidade`, `marca` e `observacao`
    - Definir array `mockData.mercados` com 3 mercados ("Supermercado Extra", "Atacadão", "Mercado Municipal")
    - Definir array `mockData.registros` com 10+ registros de preço cobrindo múltiplos produtos e mercados, com datas calculadas dinamicamente via `new Date(Date.now() - N * 86400000)` nos últimos 30 dias
    - Definir array `mockData.listas` com 2 listas de compras (`ativa: true`), cada uma com 3–6 `ItemDeLista` com `ultimoPrecoRegistrado` entre R$ 1,00 e R$ 50,00 e quantidades entre 1 e 5
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [x] 2.2 Implementar `appState` e funções puras de lógica de negócio
    - Inicializar `appState` com `activeTab: 'produtos'`, `activeListaId: null` e cópias dos arrays de `mockData`
    - Implementar `calcSubtotal(item)`: retorna `item.ultimoPrecoRegistrado * item.quantidade` ou `null` se preço for nulo
    - Implementar `calcTotalLista(itens)`: soma os subtotais não-nulos de todos os itens
    - Implementar `sortRegistrosByDateDesc(registros)`: ordena por campo `data` em ordem decrescente
    - Implementar `getUltimoRegistro(registros, produtoId, mercadoId)`: retorna o registro mais recente para o par produto+mercado
    - Implementar `getNomeProduto(produtos, id)`: retorna `nome` ou `"(desconhecido)"`
    - Implementar `getNomeMercado(mercados, id)`: retorna `nome` ou `"(desconhecido)"`
    - Implementar `groupProdutosByCategoria(produtos)`: retorna objeto `Record<string, Produto[]>` com chaves ordenadas alfabeticamente
    - Implementar `getComparacaoData(registros, produtoId, mercados)`: retorna array de `{ mercado, ultimoRegistro }` ordenado por valor crescente
    - Implementar `formatBRL(valor)`: formata número usando `Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' })`
    - Implementar `formatData(isoString)`: formata data usando `toLocaleDateString('pt-BR')`
    - _Requirements: 3.4, 4.3, 4.6, 6.3, 7.5_

  - [x] 2.3 Escrever property test para `calcSubtotal` e `calcTotalLista`
    - **Property 4: Cálculo de subtotal de item**
    - **Property 5: Total estimado da lista é soma dos subtotais**
    - **Validates: Requirements 4.3, 4.6**

  - [x] 2.4 Escrever property test para `sortRegistrosByDateDesc`
    - **Property 3: Ordenação de registros por data**
    - **Validates: Requirements 3.4**

  - [x] 2.5 Escrever property test para `getNomeProduto` e `getNomeMercado`
    - **Property 2: Resolução de nomes via ID é consistente**
    - **Validates: Requirements 3.2, 5.3**

  - [x] 2.6 Escrever property test para `getComparacaoData`
    - **Property 6: Comparação ordena por valor crescente**
    - **Property 7: Badge "Melhor preço" identifica o mínimo**
    - **Validates: Requirements 6.3, 6.4**

- [x] 3. Checkpoint — Lógica pura validada
  - Garantir que todas as funções puras estão implementadas e os testes passam. Perguntar ao usuário se há dúvidas antes de prosseguir para a camada de UI.

- [x] 4. Controlador de navegação e TabBar
  - [x] 4.1 Implementar `setActiveTab(tabName)` e renderização inicial
    - Implementar `setActiveTab(tabName)`: atualiza `appState.activeTab`, chama `renderScreen()`, aplica/remove classe `.active` nos `.tab-item`
    - Implementar `renderScreen()`: despacha para a função `render*()` correta com base em `appState.activeTab` e `appState.activeListaId`
    - Adicionar event listeners de `click` em todos os `.tab-item` chamando `setActiveTab`
    - Chamar `renderScreen()` no `DOMContentLoaded` para exibir a aba "Produtos" por padrão
    - Aplicar cor azul `#007AFF` na aba ativa e cinza `#8E8E93` nas inativas via CSS e classe `.active`
    - _Requirements: 1.4, 1.5, 1.6_

  - [x] 4.2 Escrever property test para navegação mutuamente exclusiva
    - **Property 1: Navegação por abas é mutuamente exclusiva**
    - **Validates: Requirements 1.4, 1.5**

- [x] 5. Implementar funções de render das telas
  - [x] 5.1 Implementar `renderNavBar(title, action)` e `showModal` / `hideModal`
    - Implementar `renderNavBar(title, action?)`: retorna HTML string com título e botão de ação opcional
    - Implementar `showModal(htmlContent)`: injeta conteúdo no `.modal-overlay`, aplica `translateY(0)` no `.bottom-sheet`, adiciona listener de clique no overlay para fechar
    - Implementar `hideModal()`: aplica `translateY(100%)` no `.bottom-sheet`, remove o modal do DOM após 300ms
    - _Requirements: 2.1, 3.1, 4.1, 8.5_

  - [x] 5.2 Implementar `renderProdutos()`
    - Renderizar NavigationBar com título "Produtos" e botão "+"
    - Agrupar produtos via `groupProdutosByCategoria` e renderizar seções com cabeçalhos de categoria
    - Cada item da lista exibe nome, categoria e unidade
    - Adicionar event listener no botão "+" para chamar `showModal` com formulário de novo produto (campos: nome, categoria, unidade, marca, observação; botão "Cancelar")
    - Adicionar event listener em cada item da lista para exibir tela de detalhe do produto (nome, categoria, unidade, marca, observação) com botão de voltar no NavBar
    - Renderizar estado vazio com ícone de carrinho e texto "Nenhum produto cadastrado" se `appState.produtos` estiver vazio
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6_

  - [x] 5.3 Implementar `renderRegistros()`
    - Renderizar NavigationBar com título "Registros" e botão "+"
    - Ordenar registros via `sortRegistrosByDateDesc` e renderizar lista
    - Cada item exibe nome do produto (via `getNomeProduto`), nome do mercado (via `getNomeMercado`), valor em BRL (via `formatBRL`) e data (via `formatData`)
    - Adicionar event listener no botão "+" para chamar `showModal` com formulário de novo registro (campos: produto select, mercado select, valor, data; botão "Cancelar")
    - Renderizar estado vazio com ícone de etiqueta e texto "Nenhum registro de preço" se `appState.registros` estiver vazio
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

  - [x] 5.4 Implementar `renderListas()` e `renderDetalheLista(id)`
    - `renderListas()`: renderizar NavigationBar com título "Listas de Compras" e botão "+"; exibir cards com nome, quantidade de itens e total estimado (via `calcTotalLista` + `formatBRL`); adicionar event listener no "+" para modal de nova lista; adicionar event listener em cada card para navegar ao detalhe (setar `appState.activeListaId` e chamar `renderScreen()`)
    - `renderDetalheLista(id)`: renderizar NavigationBar com título da lista e botão de voltar; listar todos os `ItemDeLista` com nome do produto, quantidade e subtotal (via `calcSubtotal` + `formatBRL`, ou "—"); exibir total estimado da lista no rodapé
    - Adicionar event listener em cada checkbox de item: alternar `item.concluido` em `appState`, aplicar estilo riscado/opacidade 0.4 para concluído e normal/opacidade 1.0 para pendente, recalcular e atualizar total exibido
    - Botão de voltar: setar `appState.activeListaId = null` e chamar `renderScreen()`
    - Renderizar estado vazio com ícone de lista e texto "Nenhuma lista criada" se `appState.listas` estiver vazio
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7_

  - [x] 5.5 Escrever property test para toggle de checkbox
    - **Property 8: Toggle de checkbox preserva estado em memória**
    - **Validates: Requirements 4.5, 7.5**

  - [x] 5.6 Implementar `renderDashboard()`
    - Renderizar NavigationBar com título "Dashboard"
    - Renderizar card de resumo com três métricas: `appState.produtos.length`, `appState.mercados.length`, `appState.registros.length`
    - Renderizar seção "Últimos Registros" com os 3 registros mais recentes (via `sortRegistrosByDateDesc`), exibindo nome do produto, nome do mercado e valor em BRL
    - Renderizar seção "Listas Ativas" com total de listas onde `ativa === true` e soma dos totais estimados em BRL
    - Aplicar estilo iOS: fundo geral `#F2F2F7`, cards com fundo `#FFFFFF` e `border-radius: 10px`
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

  - [x] 5.7 Escrever property test para métricas do Dashboard
    - **Property 9: Métricas do Dashboard refletem os dados simulados**
    - **Validates: Requirements 5.2**

  - [x] 5.8 Implementar `renderComparacao()`
    - Renderizar NavigationBar com título "Comparação"
    - Renderizar elemento `<select>` populado com todos os produtos de `appState.produtos`; selecionar o primeiro produto por padrão
    - Ao carregar e ao mudar o `<select>`, chamar `getComparacaoData` e renderizar lista de mercados ordenada por valor crescente
    - Cada item da lista exibe nome do mercado, valor em BRL e data formatada do último registro
    - Destacar o primeiro item (menor valor) com badge "Melhor preço" em verde `#34C759`
    - Exibir mensagem "Sem registros de preço para este produto" se `getComparacaoData` retornar array vazio
    - Adicionar event listener `change` no `<select>` para re-renderizar a lista de comparação
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

- [x] 6. Checkpoint final — Integração completa
  - Garantir que todas as telas renderizam corretamente, a navegação por TabBar funciona, os modais abrem e fecham com animação, os checkboxes atualizam o estado e os totais são recalculados. Perguntar ao usuário se há ajustes antes de finalizar.

## Notes

- Tarefas marcadas com `*` são opcionais e podem ser puladas para um MVP mais rápido
- O arquivo `index.html` é auto-contido: todo CSS, HTML e JS ficam embutidos em um único arquivo
- Não há etapa de build — o arquivo pode ser aberto diretamente no navegador
- Os property tests requerem configuração de Vitest + fast-check (ver design.md para detalhes)
- Cada tarefa referencia requisitos específicos para rastreabilidade
- Os dados simulados usam datas calculadas dinamicamente para que os "últimos 30 dias" sejam sempre relativos à data de abertura

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1"] },
    { "id": 1, "tasks": ["1.2", "2.1"] },
    { "id": 2, "tasks": ["2.2"] },
    { "id": 3, "tasks": ["2.3", "2.4", "2.5", "2.6", "4.1"] },
    { "id": 4, "tasks": ["4.2", "5.1"] },
    { "id": 5, "tasks": ["5.2", "5.3", "5.6"] },
    { "id": 6, "tasks": ["5.4", "5.7", "5.8"] },
    { "id": 7, "tasks": ["5.5"] }
  ]
}
```
