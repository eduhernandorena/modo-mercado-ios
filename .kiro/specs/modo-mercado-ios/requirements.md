# Requirements Document

<!-- Modo Mercado — Documento de Requisitos -->

## Introduction

O Modo Mercado é um aplicativo móvel que permite ao usuário registrar, acompanhar e comparar preços de produtos do dia a dia. O objetivo central é transformar compras comuns em dados úteis para economia doméstica, ajudando o usuário a identificar aumentos graduais de preço, promoções falsas e oportunidades reais de economia.

O aplicativo opera 100% offline, sem dependência de backend ou conectividade de rede. Este documento cobre os requisitos do MVP, composto por seis módulos principais: Cadastro de Produto, Registro de Preço, Histórico de Preços, Lista de Compras, Dashboard e Comparação Entre Mercados.

---

## Glossary

- **App**: O aplicativo Modo Mercado.
- **Usuário**: Pessoa que utiliza o App para registrar e consultar preços.
- **Produto**: Item de consumo cadastrado pelo Usuário, identificado por nome, categoria, marca, quantidade e unidade.
- **Registro_de_Preco**: Entrada que associa um Produto a um valor monetário, um Mercado e uma data.
- **Mercado**: Estabelecimento comercial onde o Usuário realiza compras.
- **Historico**: Conjunto ordenado cronologicamente de Registros_de_Preco de um Produto.
- **Lista_de_Compras**: Coleção de itens planejados para uma sessão de compras.
- **Item_de_Lista**: Entrada na Lista_de_Compras que referencia um Produto com quantidade desejada.
- **Dashboard**: Tela de resumo financeiro com métricas agregadas de gastos e economia.
- **Categoria**: Classificação temática de um Produto (ex.: Laticínios, Higiene, Bebidas).
- **Repositorio_Local**: Banco de dados persistido localmente no dispositivo.
- **Formatador**: Componente responsável por serializar e desserializar dados entre modelos de domínio e formatos de armazenamento/exibição.

---

## Requirements

### Requirement 1: Cadastro de Produto

**User Story:** Como Usuário, quero cadastrar produtos com suas informações básicas, para que eu possa registrar preços e acompanhar a evolução de cada item individualmente.

#### Acceptance Criteria

1. THE App SHALL exibir um formulário de cadastro de Produto contendo os campos: nome, categoria, marca, quantidade, unidade e observação.
2. WHEN o Usuário submete o formulário de cadastro, THE App SHALL validar que os campos nome, categoria e unidade estão preenchidos antes de salvar.
3. IF o Usuário submete o formulário com nome, categoria ou unidade ausentes, THEN THE App SHALL exibir uma mensagem de erro descritiva indicando qual campo está faltando.
4. WHEN o Usuário submete um formulário válido de cadastro, THE App SHALL persistir o Produto no Repositorio_Local e exibir confirmação de sucesso.
5. THE App SHALL permitir que o Usuário edite qualquer campo de um Produto já cadastrado.
6. WHEN o Usuário edita um Produto, THE App SHALL aplicar as mesmas validações do cadastro inicial antes de salvar as alterações.
7. THE App SHALL exibir a lista de Produtos cadastrados ordenada alfabeticamente por nome.
8. WHEN o Usuário pesquisa por nome ou Categoria na lista de Produtos, THE App SHALL filtrar e exibir apenas os Produtos que correspondem ao termo buscado.
9. THE App SHALL permitir que o Usuário exclua um Produto cadastrado.
10. WHEN o Usuário solicita a exclusão de um Produto que possui Registros_de_Preco associados, THE App SHALL exibir um aviso informando que os registros vinculados também serão removidos e solicitar confirmação antes de prosseguir.

---

### Requirement 2: Registro de Preço

**User Story:** Como Usuário, quero registrar o preço de um produto em um mercado específico, para que eu possa construir um histórico de preços ao longo do tempo.

#### Acceptance Criteria

1. THE App SHALL exibir um formulário de Registro_de_Preco contendo os campos: produto, valor, mercado e data.
2. WHEN o Usuário submete o formulário de Registro_de_Preco, THE App SHALL validar que os campos produto, valor e mercado estão preenchidos e que o valor é um número positivo.
3. IF o Usuário submete o formulário com produto, valor ou mercado ausentes, THEN THE App SHALL exibir uma mensagem de erro descritiva indicando qual campo está faltando.
4. IF o Usuário informa um valor menor ou igual a zero no campo valor, THEN THE App SHALL exibir uma mensagem de erro indicando que o valor deve ser positivo.
5. WHEN o Usuário submete um formulário válido de Registro_de_Preco, THE App SHALL persistir o registro no Repositorio_Local associado ao Produto e ao Mercado informados.
6. WHEN o Usuário abre o formulário de Registro_de_Preco, THE App SHALL preencher automaticamente o campo data com a data atual do dispositivo, independentemente do estado de validade dos demais campos do formulário.
7. THE App SHALL permitir que o Usuário selecione uma data diferente da atual para o Registro_de_Preco.
8. THE App SHALL permitir que o Usuário anexe uma foto opcional ao Registro_de_Preco.
9. WHEN o Usuário anexa uma foto ao Registro_de_Preco, THE App SHALL armazenar a imagem localmente e exibi-la na tela de detalhes do registro.
10. THE App SHALL permitir que o Usuário selecione um Mercado existente ou cadastre um novo Mercado diretamente no formulário de Registro_de_Preco.

---

### Requirement 3: Histórico de Preços

**User Story:** Como Usuário, quero visualizar o histórico de preços de um produto, para que eu possa entender a evolução de valores ao longo do tempo e identificar o melhor momento para comprar.

#### Acceptance Criteria

1. WHEN o Usuário acessa o Historico de um Produto, THE App SHALL exibir todos os Registros_de_Preco daquele Produto ordenados cronologicamente do mais recente ao mais antigo.
2. THE App SHALL calcular e exibir o menor preço registrado para o Produto considerando todos os Registros_de_Preco disponíveis.
3. THE App SHALL calcular e exibir o maior preço registrado para o Produto considerando todos os Registros_de_Preco disponíveis.
4. THE App SHALL calcular e exibir a média aritmética dos valores de todos os Registros_de_Preco do Produto.
5. THE App SHALL exibir um gráfico de linha representando a evolução temporal dos preços do Produto, com o eixo horizontal representando a data e o eixo vertical representando o valor.
6. WHEN o Produto possui apenas um Registro_de_Preco, THE App SHALL exibir as métricas de menor preço, maior preço e média com o valor desse único registro e SHALL exibir o gráfico de linha com um único ponto representando esse registro.
7. WHEN o Produto não possui nenhum Registro_de_Preco, THE App SHALL exibir uma mensagem informando que não há registros disponíveis e SHALL ocultar as métricas de menor preço, maior preço e média.
8. THE App SHALL permitir que o Usuário filtre o Historico por Mercado, exibindo apenas os registros do Mercado selecionado.
9. THE App SHALL permitir que o Usuário filtre o Historico por período de datas, exibindo apenas os registros dentro do intervalo selecionado.
10. THE Formatador SHALL serializar e desserializar Registros_de_Preco entre o modelo de domínio e o formato de armazenamento do Repositorio_Local.
11. FOR ALL Registros_de_Preco válidos, serializar e depois desserializar um registro SHALL produzir um objeto equivalente ao original (propriedade de round-trip).

---

### Requirement 4: Lista de Compras

**User Story:** Como Usuário, quero criar e gerenciar uma lista de compras, para que eu possa planejar minhas compras com estimativa de custo e organização por categoria.

#### Acceptance Criteria

1. THE App SHALL permitir que o Usuário crie uma Lista_de_Compras com um nome identificador.
2. THE App SHALL permitir que o Usuário adicione Itens_de_Lista a uma Lista_de_Compras, selecionando apenas Produtos que possuam ao menos um Registro_de_Preco cadastrado e informando a quantidade desejada.
3. WHEN o Usuário tenta adicionar à Lista_de_Compras um Produto que não possui nenhum Registro_de_Preco, THE App SHALL exibir uma mensagem informando que o Produto não pode ser adicionado por não ter preço registrado.
4. WHEN o Usuário adiciona um Item_de_Lista, THE App SHALL exibir o Item_de_Lista na lista agrupado pela Categoria do Produto correspondente.
5. THE App SHALL permitir que o Usuário marque um Item_de_Lista como concluído.
6. WHEN o Usuário marca um Item_de_Lista como concluído, THE App SHALL aplicar uma distinção visual ao item para diferenciá-lo dos itens pendentes.
7. THE App SHALL calcular e exibir a estimativa de total da Lista_de_Compras com base no último preço registrado de cada Produto.
8. WHEN um Produto de um Item_de_Lista não possui nenhum Registro_de_Preco, THE App SHALL impedir a adição desse Produto à Lista_de_Compras conforme definido no critério 3.
9. THE App SHALL permitir que o Usuário remova um Item_de_Lista de uma Lista_de_Compras.
10. THE App SHALL permitir que o Usuário exclua uma Lista_de_Compras completa.
11. WHEN o Usuário exclui uma Lista_de_Compras, THE App SHALL solicitar confirmação antes de prosseguir com a exclusão.
12. THE App SHALL permitir que o Usuário mantenha múltiplas Listas_de_Compras simultaneamente.

---

### Requirement 5: Dashboard

**User Story:** Como Usuário, quero visualizar um resumo financeiro das minhas compras, para que eu possa entender meus padrões de gasto e identificar oportunidades de economia.

#### Acceptance Criteria

1. THE App SHALL exibir o total gasto no mês corrente, calculado com base na soma dos valores de todos os Registros_de_Preco com data dentro do mês atual.
2. THE App SHALL exibir as três Categorias com maior soma de gastos no mês corrente.
3. THE App SHALL exibir os três Produtos com maior percentual de aumento de preço no mês corrente em relação ao mês anterior.
4. THE App SHALL calcular e exibir a economia estimada do Usuário, definida como a diferença entre o maior preço registrado e o preço efetivamente pago para cada Produto no mês corrente, somada entre todos os Produtos.
5. WHEN todos os valores calculados do Dashboard são zero ou indisponíveis por ausência de Registros_de_Preco no mês corrente, THE App SHALL exibir o Dashboard com valores zerados e uma mensagem orientando o Usuário a registrar preços.
6. WHEN o Usuário seleciona uma Categoria no Dashboard, THE App SHALL navegar para uma tela de detalhes exibindo os Produtos e Registros_de_Preco daquela Categoria no mês corrente.
7. WHEN o Usuário seleciona um Produto no Dashboard, THE App SHALL navegar para o Historico de Preços daquele Produto.
8. THE App SHALL atualizar os dados do Dashboard automaticamente sempre que um novo Registro_de_Preco for adicionado ou editado.

---

### Requirement 6: Comparação Entre Mercados

**User Story:** Como Usuário, quero comparar o preço de um produto em diferentes mercados, para que eu possa identificar onde comprar cada item pelo menor preço.

#### Acceptance Criteria

1. WHEN o Usuário acessa a tela de Comparação de um Produto, THE App SHALL exibir uma lista com o último preço registrado daquele Produto em cada Mercado onde ele foi registrado.
2. THE App SHALL ordenar a lista de comparação do menor para o maior preço.
3. THE App SHALL destacar visualmente o Mercado com o menor preço na lista de comparação.
4. WHEN um Produto possui Registro_de_Preco em apenas um Mercado, THE App SHALL exibir a comparação com esse único Mercado e uma mensagem informando que não há outros mercados para comparar.
5. WHEN um Produto não possui nenhum Registro_de_Preco, THE App SHALL exibir uma mensagem informando que não é possível realizar a comparação por ausência de registros.
6. THE App SHALL exibir a data do último Registro_de_Preco de cada Mercado na lista de comparação, para que o Usuário possa avaliar a atualidade das informações.
7. THE App SHALL permitir que o Usuário acesse a tela de Comparação a partir do Historico de Preços do Produto.

---

### Requirement 7: Persistência e Integridade dos Dados

**User Story:** Como Usuário, quero que meus dados sejam armazenados de forma confiável no dispositivo, para que eu não perca informações entre sessões do aplicativo.

#### Acceptance Criteria

1. THE App SHALL persistir todos os Produtos, Registros_de_Preco, Mercados e Listas_de_Compras no Repositorio_Local do dispositivo.
2. WHEN o App é encerrado e reaberto, THE App SHALL restaurar todos os dados previamente persistidos sem perda de informação.
3. IF uma operação de escrita, leitura ou validação no Repositorio_Local falhar, THEN THE App SHALL exibir uma mensagem de erro ao Usuário descrevendo a falha e não alterar o estado dos dados em memória.
4. THE Formatador SHALL serializar Produtos, Registros_de_Preco, Mercados e Listas_de_Compras para o formato de armazenamento do Repositorio_Local.
5. THE Formatador SHALL desserializar dados do Repositorio_Local para os modelos de domínio correspondentes.
6. FOR ALL entidades válidas (Produto, Registro_de_Preco, Mercado, Item_de_Lista), serializar e depois desserializar a entidade SHALL produzir um objeto equivalente ao original (propriedade de round-trip).
7. WHEN o processo de restauração dos dados ao reabrir o App falhar devido a arquivos corrompidos ou erros de armazenamento, THE App SHALL exibir uma mensagem de erro informando o Usuário sobre a falha na restauração e SHALL iniciar com um estado de dados vazio para permitir o uso contínuo do aplicativo.
