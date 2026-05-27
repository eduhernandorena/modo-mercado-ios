# Design Document — Protótipo Interativo ModoMercado

## Overview

O protótipo interativo é uma aplicação web estática (HTML/CSS/JS puro, sem frameworks) que simula fielmente a interface do app iOS ModoMercado. O objetivo é permitir demonstrações para stakeholders e validação de UX sem necessidade de build nativo.

A aplicação é entregue como um único arquivo `index.html` auto-contido (ou um conjunto mínimo de arquivos estáticos) que pode ser aberto diretamente no navegador. Toda a lógica de estado, dados simulados e renderização reside no JavaScript embutido.

**Decisões de design principais:**

- **Arquivo único (`index.html`)**: elimina dependências de servidor, facilita compartilhamento por e-mail ou link direto.
- **Vanilla JS (sem frameworks)**: zero dependências externas, carregamento instantâneo, sem etapa de build.
- **Estado em memória (objeto JS)**: suficiente para uma sessão de demonstração; não persiste entre recarregamentos (comportamento esperado).
- **SF Pro via font-stack do sistema**: `-apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", system-ui` — renderiza SF Pro em macOS/iOS sem necessidade de download de fonte.

---

## Architecture

A aplicação segue uma arquitetura de **Single-Page Application (SPA) manual** com três camadas:

```
┌─────────────────────────────────────────────────────┐
│                    index.html                        │
│                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐  │
│  │   Data Layer │  │  State Layer │  │  UI Layer │  │
│  │  (mockData)  │  │  (appState)  │  │ (render*) │  │
│  └──────┬───────┘  └──────┬───────┘  └─────┬─────┘  │
│         │                 │                │         │
│         └─────────────────┴────────────────┘         │
│                     App Controller                   │
│                  (event listeners)                   │
└─────────────────────────────────────────────────────┘
```

### Fluxo de dados

```
mockData (imutável) ──► appState (mutável em sessão)
                              │
                              ▼
                    Event Listener (click/change)
                              │
                              ▼
                    Mutação de appState
                              │
                              ▼
                    renderScreen(activeTab)
                              │
                              ▼
                    DOM atualizado
```

### Estrutura de arquivos

```
interactive-prototype/
└── index.html          # Arquivo único auto-contido
    ├── <style>         # CSS completo embutido
    ├── <body>          # Shell iOS + estrutura HTML
    └── <script>        # mockData + appState + render functions
```

---

## Components and Interfaces

### 1. Shell iOS (`#ios-shell`)

Componente raiz que envolve toda a simulação.

```
┌─────────────────────────┐  ← #ios-shell (390×844px, border-radius 44px)
│  ████ 9:41  ▲ ▼ ■      │  ← #status-bar (44px)
│─────────────────────────│
│                         │
│   #screen-container     │  ← área de conteúdo (altura variável)
│   (tela ativa)          │
│                         │
│─────────────────────────│
│  🛒  🏷  📋  📊  ⇄    │  ← #tab-bar (83px: 78px tabs + 5px home indicator)
└─────────────────────────┘
```

**Responsividade:**
- `viewport ≥ 768px`: Shell centralizado, fundo `#E5E5EA`
- `viewport < 768px`: Shell ocupa 100% da largura, border-radius 0

### 2. TabBar (`#tab-bar`)

Cinco botões `.tab-item` com ícone SVG inline e rótulo de texto.

| Aba | Ícone SF Symbol (SVG) | Rótulo | `data-tab` |
|---|---|---|---|
| Produtos | cart | Produtos | `produtos` |
| Registros | tag | Registros | `registros` |
| Listas | list.bullet | Listas | `listas` |
| Dashboard | chart.bar | Dashboard | `dashboard` |
| Comparação | arrow.left.arrow.right | Comparação | `comparacao` |

**Interface JS:**
```js
function setActiveTab(tabName: string): void
// Atualiza appState.activeTab, re-renderiza a tela ativa,
// aplica classe .active nos botões da TabBar
```

### 3. Telas (Screens)

Cada tela é renderizada dinamicamente via função `render*()` que retorna HTML string e é injetada em `#screen-container`.

| Tela | Função de render | Descrição |
|---|---|---|
| Produtos | `renderProdutos()` | Lista agrupada por categoria |
| Registros | `renderRegistros()` | Lista ordenada por data desc |
| Listas | `renderListas()` | Cards de listas de compras |
| Detalhe de Lista | `renderDetalheLista(id)` | Itens com checkbox |
| Dashboard | `renderDashboard()` | Cards de métricas |
| Comparação | `renderComparacao()` | Select + tabela de preços |

### 4. Modais Bottom-Sheet (`.modal-overlay`)

Componente reutilizável para formulários simulados.

```
┌─────────────────────────┐
│  ░░░░░░░░░░░░░░░░░░░░░  │  ← overlay escuro semi-transparente
│  ┌───────────────────┐  │
│  │  ─────────────    │  │  ← drag handle
│  │  Título do Modal  │  │
│  │  ─────────────    │  │
│  │  [campos]         │  │
│  │  [Cancelar]       │  │
│  └───────────────────┘  │  ← bottom-sheet (translateY animado)
└─────────────────────────┘
```

**Interface JS:**
```js
function showModal(htmlContent: string): void
// Injeta conteúdo, aplica translateY(0), adiciona listener no overlay

function hideModal(): void
// Aplica translateY(100%), remove após 300ms (transição CSS)
```

### 5. NavigationBar (`.nav-bar`)

Componente de cabeçalho de tela com título e botão de ação opcional.

```js
function renderNavBar(title: string, action?: { icon: string, onClick: string }): string
// Retorna HTML string do nav-bar
```

---

## Data Models

Os modelos de dados do protótipo espelham diretamente os `struct` Swift do app nativo, representados como objetos JavaScript.

### Produto

```js
{
  id: string,          // UUID string
  nome: string,
  categoria: string,
  unidade: string,
  marca: string | null,
  observacao: string | null,
  criadoEm: string     // ISO 8601
}
```

### Mercado

```js
{
  id: string,
  nome: string,
  criadoEm: string     // ISO 8601
}
```

### RegistroDePreco

```js
{
  id: string,
  produtoId: string,
  mercadoId: string,
  valor: number,       // float (precisão monetária suficiente para display)
  data: string,        // ISO 8601
  criadoEm: string
}
```

### ListaDeCompras

```js
{
  id: string,
  nome: string,
  ativa: boolean,
  itens: ItemDeLista[],
  criadoEm: string
}
```

### ItemDeLista

```js
{
  id: string,
  produtoId: string,
  quantidade: number,
  concluido: boolean,
  ultimoPrecoRegistrado: number | null
}
```

### Estado da Aplicação (`appState`)

```js
const appState = {
  activeTab: 'produtos',          // aba ativa atual
  activeListaId: null,            // ID da lista em detalhe (ou null)
  produtos: [...mockData.produtos],
  mercados: [...mockData.mercados],
  registros: [...mockData.registros],
  listas: [...mockData.listas]
}
```

### Dados Simulados (`mockData`)

Objeto imutável inicializado no carregamento da página:

- **8+ Produtos** em 3+ categorias: "Laticínios", "Hortifruti", "Limpeza"
- **3 Mercados**: "Supermercado Extra", "Atacadão", "Mercado Municipal"
- **10+ Registros de Preço** com datas nos últimos 30 dias (calculadas dinamicamente via `new Date(Date.now() - N * 86400000)`)
- **2 Listas de Compras** com 3–6 itens cada, `ativa: true`

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system — essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Navegação por abas é mutuamente exclusiva

*Para qualquer* sequência de cliques em abas da TabBar, exatamente uma tela deve estar visível e exatamente uma aba deve estar no estado ativo ao final da sequência.

**Validates: Requirements 1.4, 1.5**

---

### Property 2: Resolução de nomes via ID é consistente

*Para qualquer* Registro_De_Preco nos dados simulados, o nome do produto exibido deve ser igual ao `nome` do Produto cujo `id` corresponde ao `produtoId` do registro, e o nome do mercado deve ser igual ao `nome` do Mercado cujo `id` corresponde ao `mercadoId`.

**Validates: Requirements 3.2, 5.3**

---

### Property 3: Ordenação de registros por data

*Para qualquer* lista de Registro_De_Preco exibida na tela de Registros, para todo par de registros adjacentes (i, i+1), a data do registro i deve ser maior ou igual à data do registro i+1 (ordem decrescente).

**Validates: Requirements 3.4**

---

### Property 4: Cálculo de subtotal de item

*Para qualquer* Item_De_Lista com `ultimoPrecoRegistrado` não nulo, o subtotal exibido deve ser igual a `ultimoPrecoRegistrado × quantidade`; para itens com `ultimoPrecoRegistrado` nulo, o subtotal exibido deve ser "—".

**Validates: Requirements 4.3, 4.6**

---

### Property 5: Total estimado da lista é soma dos subtotais

*Para qualquer* Lista_De_Compras, o total estimado exibido deve ser igual à soma dos `ultimoPrecoRegistrado × quantidade` de todos os Item_De_Lista que possuem `ultimoPrecoRegistrado` não nulo, independentemente do estado `concluido` de cada item.

**Validates: Requirements 4.6**

---

### Property 6: Comparação ordena por valor crescente

*Para qualquer* Produto selecionado no seletor de Comparação, a lista de mercados exibida deve estar ordenada de forma que para todo par adjacente (i, i+1), o valor do registro i seja menor ou igual ao valor do registro i+1.

**Validates: Requirements 6.3**

---

### Property 7: Badge "Melhor preço" identifica o mínimo

*Para qualquer* Produto selecionado com pelo menos um Registro_De_Preco, o badge "Melhor preço" deve aparecer exatamente no mercado cujo último registro tem o menor valor entre todos os mercados com registro para aquele produto.

**Validates: Requirements 6.4**

---

### Property 8: Toggle de checkbox preserva estado em memória

*Para qualquer* Item_De_Lista, após alternar o estado `concluido` via checkbox, o estado armazenado em `appState` deve refletir o novo valor; uma segunda alternância deve restaurar o valor original (idempotência do toggle).

**Validates: Requirements 4.5, 7.5**

---

### Property 9: Métricas do Dashboard refletem os dados simulados

*Para qualquer* conjunto de dados simulados, os contadores exibidos no card de resumo do Dashboard (total de produtos, mercados e registros) devem ser iguais aos comprimentos dos arrays correspondentes em `appState`.

**Validates: Requirements 5.2**

---

## Error Handling

Como o protótipo opera exclusivamente com dados simulados em memória, não há I/O externo. O tratamento de erros foca em estados de borda da UI:

| Situação | Comportamento |
|---|---|
| Array vazio (produtos, registros, listas) | Exibe componente de estado vazio com ícone e mensagem específica por tela |
| Produto sem registros de preço (tela Comparação) | Exibe mensagem "Sem registros de preço para este produto" |
| `produtoId` ou `mercadoId` não encontrado no lookup | Exibe string `"(desconhecido)"` — não deve ocorrer com dados simulados consistentes |
| Modal aberto sem fechar | Clique no overlay escuro fecha o modal (mesmo comportamento do botão Cancelar) |
| Viewport muito pequeno (< 320px) | Shell ocupa 100% da largura; layout pode ficar comprimido mas permanece funcional |

---

## Testing Strategy

Este protótipo é uma aplicação web estática de demonstração. A estratégia de testes foca em verificação de comportamento via testes de unidade para as funções de lógica pura (cálculos, ordenação, filtragem) e testes de exemplo para comportamentos de UI.

**PBT não é aplicável** para a maioria das funcionalidades deste protótipo porque:
- A renderização HTML é uma operação de side-effect (manipulação de DOM) sem retorno verificável por propriedade
- Os dados simulados são fixos e pequenos — não há espaço de entrada variável que justifique 100+ iterações para a maioria dos critérios
- As interações de UI (modais, navegação) são melhor verificadas por testes de exemplo

**Exceção**: As funções de lógica pura (cálculo de subtotal, ordenação, filtragem de comparação, resolução de IDs) são candidatas a property-based testing e estão formalizadas nas Correctness Properties acima.

### Testes de Unidade (funções puras)

Funções a extrair e testar isoladamente:

```js
// Cálculo de subtotal
calcSubtotal(item: ItemDeLista): number | null

// Cálculo de total da lista
calcTotalLista(itens: ItemDeLista[]): number

// Ordenação de registros por data desc
sortRegistrosByDateDesc(registros: RegistroDePreco[]): RegistroDePreco[]

// Último registro por produto+mercado
getUltimoRegistro(registros: RegistroDePreco[], produtoId: string, mercadoId: string): RegistroDePreco | null

// Lookup de nome por ID
getNomeProduto(produtos: Produto[], id: string): string
getNomeMercado(mercados: Mercado[], id: string): string

// Agrupamento de produtos por categoria
groupProdutosByCategoria(produtos: Produto[]): Record<string, Produto[]>

// Comparação: registros mais recentes por mercado, ordenados por valor
getComparacaoData(registros: RegistroDePreco[], produtoId: string, mercados: Mercado[]): ComparacaoItem[]
```

### Testes de Exemplo (comportamento de UI)

| Cenário | Verificação |
|---|---|
| Carga inicial | Aba "Produtos" ativa, 8+ produtos visíveis agrupados por categoria |
| Clique em aba | Tela correspondente visível, aba com classe `.active` |
| Abrir modal "+" | Bottom-sheet visível com `translateY(0)` |
| Fechar modal (Cancelar / overlay) | Bottom-sheet com `translateY(100%)` após 300ms |
| Marcar item como concluído | Texto riscado, opacidade 0.4 |
| Desmarcar item | Texto normal, opacidade 1.0 |
| Selecionar produto na Comparação | Lista de mercados atualizada, badge no menor preço |
| Estado vazio (array vazio) | Mensagem de estado vazio visível |

### Ferramentas sugeridas

- **Testes de unidade**: [Vitest](https://vitest.dev/) (zero config, ESM nativo) ou Jest
- **Testes de UI/integração**: Playwright ou Cypress (opcional para protótipo)
- **Property-based testing** (para funções puras): [fast-check](https://fast-check.dev/) (JavaScript)

### Configuração de property tests

Cada property test deve rodar mínimo 100 iterações e ser anotado com:

```js
// Feature: interactive-prototype, Property N: <texto da propriedade>
test.prop([...arbitraries], { numRuns: 100 }, (inputs) => {
  // ...
})
```
