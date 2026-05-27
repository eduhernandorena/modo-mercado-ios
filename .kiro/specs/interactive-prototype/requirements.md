# Requirements Document

## Introduction

O protótipo interativo do ModoMercado é uma aplicação web (HTML/CSS/JS) que simula fielmente a interface do app iOS de lista de compras. O objetivo é demonstrar o fluxo de navegação e as telas principais do app para stakeholders e validação de UX, sem necessidade de build nativo. O protótipo deve reproduzir a aparência de um iPhone com TabBar inferior e as cinco telas principais: Produtos, Registros, Listas de Compras, Dashboard e Comparação.

## Glossary

- **Protótipo**: Aplicação web estática (HTML/CSS/JS) que simula a interface do app iOS ModoMercado.
- **Shell_iOS**: Componente visual que envolve o conteúdo simulando a moldura de um iPhone com barra de status, área de conteúdo e TabBar.
- **TabBar**: Barra de navegação inferior com cinco abas, replicando o componente `TabView` do SwiftUI.
- **Tela**: Área de conteúdo exibida dentro do Shell_iOS correspondente a uma aba selecionada.
- **Produto**: Entidade com nome, categoria, unidade, marca opcional e observação opcional.
- **Lista_De_Compras**: Entidade com nome, lista de itens e total estimado.
- **Item_De_Lista**: Entidade com produto associado (`produtoId`), quantidade, estado concluído e último preço registrado (opcional).
- **Registro_De_Preco**: Entidade com produto (`produtoId`), mercado (`mercadoId`), valor (número decimal), data (ISO 8601) e foto opcional.
- **Mercado**: Entidade com nome e data de criação.
- **Dado_Simulado**: Conjunto de dados fictícios pré-definidos no JavaScript para popular as telas do protótipo.
- **Estado_Ativo**: Condição em que uma aba da TabBar está selecionada e sua tela correspondente está visível.
- **BRL**: Formato de moeda brasileira, exibido como "R$ X.XXX,XX" usando `Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' })`.
- **Data_Formatada**: Data exibida no formato "DD/MM/AAAA" usando `toLocaleDateString('pt-BR')`.

---

## Requirements

### Requirement 1: Shell iOS e Navegação por Abas

**User Story:** Como demonstrador do produto, quero visualizar o protótipo dentro de uma moldura de iPhone com TabBar funcional, para que a apresentação transmita fielmente a experiência do app nativo.

#### Acceptance Criteria

1. THE Shell_iOS SHALL renderizar uma moldura visual de iPhone centralizada na página web, com largura de 390px e altura de 844px, simulando o iPhone 14.
2. THE Shell_iOS SHALL exibir uma barra de status superior com horário fixo "9:41" e ícones de sinal, Wi-Fi e bateria.
3. THE TabBar SHALL exibir cinco abas na parte inferior do Shell_iOS, com ícone e rótulo para cada aba: "Produtos" (ícone cart), "Registros" (ícone tag), "Listas" (ícone list.bullet), "Dashboard" (ícone chart.bar) e "Comparação" (ícone arrow.left.arrow.right).
4. WHEN o usuário toca em uma aba da TabBar, THE Shell_iOS SHALL exibir a Tela correspondente à aba selecionada e ocultar as demais.
5. WHILE uma aba está em Estado_Ativo, THE TabBar SHALL renderizar o ícone e o rótulo dessa aba na cor azul sistema iOS (#007AFF); as abas inativas SHALL renderizar ícone e rótulo em cinza secundário (#8E8E93).
6. THE Shell_iOS SHALL exibir a aba "Produtos" em Estado_Ativo ao carregar o protótipo pela primeira vez.

---

### Requirement 2: Tela de Produtos

**User Story:** Como demonstrador do produto, quero visualizar a tela de Produtos com uma lista de itens cadastrados, para que os stakeholders entendam como o catálogo de produtos é apresentado.

#### Acceptance Criteria

1. THE Tela SHALL exibir um NavigationBar com título "Produtos" e um botão "+" no canto superior direito; WHEN o usuário toca no botão "+", THE Tela SHALL exibir um modal bottom-sheet com formulário de novo produto.
2. THE Tela SHALL exibir uma lista com no mínimo 5 Dado_Simulado de Produto, cada item mostrando nome, categoria e unidade.
3. WHEN o usuário toca no botão "+", THE Tela SHALL exibir um modal simulado de formulário com campos para nome, categoria, unidade, marca e observação; o modal SHALL incluir um botão "Cancelar" que o dispensa sem salvar.
4. WHEN o usuário toca em um Produto na lista, THE Tela SHALL exibir uma tela de detalhe com todas as propriedades do Produto: nome, categoria, unidade, marca e observação; a tela de detalhe SHALL exibir um botão de voltar no NavigationBar.
5. THE Tela SHALL agrupar os Dado_Simulado de Produto por categoria em ordem alfabética, exibindo cabeçalhos de seção para cada grupo.
6. IF nenhum Produto estiver cadastrado, THEN THE Tela SHALL exibir uma mensagem de estado vazio com ícone de carrinho e texto "Nenhum produto cadastrado".

---

### Requirement 3: Tela de Registros de Preço

**User Story:** Como demonstrador do produto, quero visualizar a tela de Registros com entradas de preço por produto e mercado, para que os stakeholders entendam como o rastreamento de preços funciona.

#### Acceptance Criteria

1. THE Tela SHALL exibir um NavigationBar com título "Registros" e um botão "+" no canto superior direito.
2. THE Tela SHALL exibir uma lista com no mínimo 5 Dado_Simulado de Registro_De_Preco, cada item mostrando nome do produto (resolvido via `produtoId`), nome do mercado (resolvido via `mercadoId`), valor formatado em BRL e data formatada em Data_Formatada.
3. WHEN o usuário toca no botão "+", THE Tela SHALL exibir um modal bottom-sheet simulado com campos para produto (select), mercado (select), valor (número) e data (date); o modal SHALL incluir um botão "Cancelar" que o dispensa sem salvar.
4. THE Tela SHALL exibir os registros ordenados pelo campo `data` em ordem decrescente, com o registro de data mais recente no topo.
5. IF nenhum Registro_De_Preco estiver cadastrado, THEN THE Tela SHALL exibir uma mensagem de estado vazio com ícone de etiqueta e texto "Nenhum registro de preço".

---

### Requirement 4: Tela de Listas de Compras

**User Story:** Como demonstrador do produto, quero visualizar a tela de Listas de Compras com listas ativas e seus itens, para que os stakeholders entendam o fluxo de criação e uso de listas.

#### Acceptance Criteria

1. THE Tela SHALL exibir um NavigationBar com título "Listas de Compras" e um botão "+" no canto superior direito; WHEN o usuário toca no botão "+", THE Tela SHALL exibir um modal bottom-sheet com campo de nome da lista e botão "Cancelar".
2. THE Tela SHALL exibir no mínimo 2 Dado_Simulado de Lista_De_Compras, cada card mostrando nome da lista, quantidade de itens e total estimado formatado em BRL.
3. WHEN o usuário toca em uma Lista_De_Compras, THE Tela SHALL exibir a tela de detalhe da lista com todos os Item_De_Lista; cada item SHALL mostrar o nome do produto (resolvido via `produtoId`), quantidade e subtotal estimado (último preço × quantidade, ou "—" se sem preço registrado).
4. WHILE a tela de detalhe da lista está visível, THE Tela SHALL exibir um botão de voltar no NavigationBar; WHEN o usuário toca no botão de voltar, THE Tela SHALL retornar à tela de lista de listas.
5. WHEN o usuário toca no checkbox de um Item_De_Lista na tela de detalhe, THE Tela SHALL alternar o estado visual do item: concluído exibe texto riscado e opacidade 0.4; pendente exibe texto normal e opacidade 1.0.
6. WHILE a tela de detalhe está visível, WHEN o estado de qualquer Item_De_Lista é alterado, THE Tela SHALL recalcular e exibir o total estimado somando os subtotais de todos os Item_De_Lista que possuem preço registrado, independentemente do estado concluído.
7. IF nenhuma Lista_De_Compras estiver cadastrada, THEN THE Tela SHALL exibir uma mensagem de estado vazio com ícone de lista e texto "Nenhuma lista criada".

---

### Requirement 5: Tela de Dashboard

**User Story:** Como demonstrador do produto, quero visualizar a tela de Dashboard com resumos e métricas do uso do app, para que os stakeholders entendam o valor analítico da ferramenta.

#### Acceptance Criteria

1. THE Tela SHALL exibir um NavigationBar com título "Dashboard".
2. THE Tela SHALL exibir um card de resumo com três métricas: total de Produto cadastrados, total de Mercado cadastrados e total de Registro_De_Preco registrados, calculados a partir dos Dado_Simulado.
3. THE Tela SHALL exibir uma seção "Últimos Registros" com os 3 Registro_De_Preco de `data` mais recente, mostrando nome do produto (resolvido via `produtoId`), nome do mercado (resolvido via `mercadoId`) e valor em BRL.
4. THE Tela SHALL exibir uma seção "Listas Ativas" com o total de Lista_De_Compras cujo campo `ativa` seja `true` e o valor total estimado somado de todas essas listas em BRL.
5. THE Tela SHALL exibir os cards e seções com visual de lista agrupada no estilo iOS: fundo geral #F2F2F7, cards com fundo #FFFFFF e border-radius de 10px.

---

### Requirement 6: Tela de Comparação de Preços

**User Story:** Como demonstrador do produto, quero visualizar a tela de Comparação com preços de um produto em diferentes mercados, para que os stakeholders entendam a funcionalidade de inteligência de compra.

#### Acceptance Criteria

1. THE Tela SHALL exibir um NavigationBar com título "Comparação".
2. THE Tela SHALL exibir um seletor de Produto (elemento `<select>`) no topo da tela, populado com todos os Dado_Simulado de Produto; ao carregar, o primeiro Produto da lista SHALL estar selecionado por padrão.
3. WHEN o usuário seleciona um Produto no seletor, THE Tela SHALL exibir uma lista de Mercado com o Registro_De_Preco de `data` mais recente desse produto em cada mercado, ordenada do menor para o maior valor.
4. THE Tela SHALL destacar visualmente o Mercado com o menor valor para o Produto selecionado com um badge "Melhor preço" em verde (#34C759).
5. THE Tela SHALL exibir a Data_Formatada do último registro ao lado de cada preço.
6. IF nenhum Registro_De_Preco existir para o Produto selecionado, THEN THE Tela SHALL exibir uma mensagem "Sem registros de preço para este produto".

---

### Requirement 7: Dados Simulados e Estado da Aplicação

**User Story:** Como demonstrador do produto, quero que o protótipo contenha dados fictícios realistas pré-carregados, para que a demonstração seja convincente sem necessidade de cadastro manual.

#### Acceptance Criteria

1. THE Protótipo SHALL inicializar com no mínimo 8 Dado_Simulado de Produto distribuídos em pelo menos 3 categorias distintas (ex: "Laticínios", "Hortifruti", "Limpeza").
2. THE Protótipo SHALL inicializar com no mínimo 3 Dado_Simulado de Mercado com nomes realistas (ex: "Supermercado Extra", "Atacadão", "Mercado Municipal").
3. THE Protótipo SHALL inicializar com no mínimo 10 Dado_Simulado de Registro_De_Preco cobrindo múltiplos produtos e mercados, com datas variadas nos últimos 30 dias (entre D-30 e D-0 em relação à data de abertura do protótipo).
4. THE Protótipo SHALL inicializar com no mínimo 2 Dado_Simulado de Lista_De_Compras, cada uma contendo entre 3 e 6 Item_De_Lista com quantidades entre 1 e 5 e preços entre R$ 1,00 e R$ 50,00.
5. WHEN o usuário interage com elementos do protótipo (marcar item, abrir modal), THE Protótipo SHALL manter o estado da interação em memória durante a sessão sem recarregar a página.

---

### Requirement 8: Fidelidade Visual ao iOS

**User Story:** Como demonstrador do produto, quero que o protótipo reproduza o visual do iOS com precisão suficiente para transmitir a experiência do app nativo, para que a apresentação seja profissional e convincente.

#### Acceptance Criteria

1. THE Protótipo SHALL utilizar a família tipográfica SF Pro (ou fallback `-apple-system, system-ui, BlinkMacSystemFont`) em todos os textos, com pesos: título grande 700/34px, título de navegação 600/17px, corpo 400/17px e legenda 400/12px.
2. THE Protótipo SHALL utilizar a paleta de cores do sistema iOS: azul primário (#007AFF), verde (#34C759), fundo primário (#F2F2F7), fundo secundário (#FFFFFF), separador (#C6C6C8), texto primário (#000000) e texto secundário (#8E8E93).
3. THE Shell_iOS SHALL aplicar safe areas simuladas: 44px no topo (status bar) e 83px na base (TabBar com home indicator de 5px).
4. THE Protótipo SHALL exibir listas no estilo iOS com separadores de 1px em #C6C6C8 entre itens, fundo branco nos cards e fundo #F2F2F7 na área geral.
5. THE Protótipo SHALL exibir modais com apresentação bottom-sheet: iniciam fora da tela (translateY 100%) e animam para posição final (translateY 0) em 300ms com easing ease-out.
6. THE Protótipo SHALL ser responsivo para visualização em desktop (viewport ≥ 768px), mantendo o Shell_iOS centralizado com fundo #E5E5EA ao redor; em viewports menores, o Shell_iOS SHALL ocupar 100% da largura.
