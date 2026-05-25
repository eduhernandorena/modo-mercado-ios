# Implementation Plan: Modo Mercado Flutter

## Overview

Implementação incremental do MVP do Modo Mercado em Flutter + Dart seguindo Clean Architecture + Feature-First. A stack é: Flutter 3.x, Riverpod 2.x, Drift (SQLite), fl_chart, GoRouter, equatable, faker. Toda a lógica de negócio é testável em Linux sem emulador. O CI/CD usa GitHub Actions com job `test` (ubuntu) e job `build-ios` (macos).

---

## Tasks

- [ ] 1. Setup do projeto Flutter e infraestrutura de CI
  - [ ] 1.1 Criar projeto Flutter e configurar dependências
    - Executar `flutter create modo_mercado --org com.modomercado`
    - Adicionar ao `pubspec.yaml`: `drift`, `drift_flutter`, `riverpod`, `flutter_riverpod`, `go_router`, `fl_chart`, `equatable`, `uuid`, `path_provider`, `image_picker`
    - Adicionar dev dependencies: `build_runner`, `drift_dev`, `flutter_test`, `faker`, `mocktail`
    - _Requisitos: 7.1_

  - [ ] 1.2 Criar estrutura de diretórios Feature-First
    - Criar pastas: `lib/app/`, `lib/core/domain/models/`, `lib/core/domain/errors/`, `lib/core/protocols/`, `lib/core/formatters/`
    - Criar pastas de features: `lib/features/{produtos,registros,historico,lista_de_compras,dashboard,comparacao}/{domain/use_cases,data,presentation}/`
    - Criar pastas de infraestrutura: `lib/infrastructure/database/{tables,daos}/`, `lib/infrastructure/repositories/`
    - Criar pastas de testes espelhando `lib/`: `test/core/`, `test/features/`, `test/infrastructure/`
    - _Requisitos: 7.1_

  - [ ] 1.3 Configurar GitHub Actions
    - Criar `.github/workflows/ci.yml` com job `test` (ubuntu-latest): `flutter pub get`, `flutter analyze`, `flutter test --coverage`
    - Adicionar job `build-ios` (macos-latest, `needs: test`): `flutter pub get`, `flutter build ipa --no-codesign`, upload artifact `build/ios/ipa/*.ipa`
    - _Requisitos: 7.1_


- [ ] 2. Modelos de domínio, erros e formatador monetário
  - [ ] 2.1 Implementar modelos de domínio em Dart
    - Criar `produto.dart`, `registro_de_preco.dart`, `mercado.dart`, `lista_de_compras.dart`, `item_de_lista.dart` como classes imutáveis com `Equatable`
    - Implementar propriedades computadas `totalEstimadoCentavos` em `ListaDeCompras` e `subtotalEstimadoCentavos` em `ItemDeLista`
    - Usar `int` para todos os valores monetários (centavos) — sem `double` para dinheiro
    - _Requisitos: 1.1, 2.1, 4.1, 7.4, 7.5_

  - [ ] 2.2 Implementar `AppError` com sealed class
    - Criar `app_error.dart` com todos os casos: `campoObrigatorioAusente`, `valorInvalido`, `produtoSemPreco`, `falhaAoSalvar`, `falhaAoLer`, `falhaAoExcluir`, `dadosCorrempidos`, `produtoPossuiRegistros`, `listaVazia`
    - Implementar `mensagem` e `sugestao` para cada caso
    - _Requisitos: 1.3, 2.3, 2.4, 4.3, 7.3_

  - [ ] 2.3 Implementar `MoneyFormatter`
    - Criar `money_formatter.dart` com `format(int centavos) → String` (ex: `1250 → "R$ 12,50"`)
    - Implementar `parse(String input) → int` com tratamento de vírgula/ponto decimal
    - Lançar `AppError.valorInvalido` para inputs inválidos ou não-positivos
    - _Requisitos: 2.2, 2.4, 7.4, 7.5_


- [ ] 3. Persistência Drift: tabelas, DAOs e repositórios
  - [ ] 3.1 Definir tabelas Drift e gerar código
    - Criar `produtos_table.dart`, `registros_table.dart`, `mercados_table.dart`, `listas_table.dart`, `itens_table.dart` com colunas tipadas
    - Armazenar `valorCentavos` como `IntColumn` (sem `RealColumn` para dinheiro)
    - Criar `app_database.dart` com `@DriftDatabase` incluindo todas as tabelas
    - Executar `dart run build_runner build` para gerar `app_database.g.dart`
    - _Requisitos: 7.1, 7.2_

  - [ ] 3.2 Implementar interfaces de repositório
    - Criar `produto_repository.dart`, `registro_repository.dart`, `mercado_repository.dart`, `lista_repository.dart` como abstract classes em `lib/core/protocols/`
    - _Requisitos: 7.1_

  - [ ] 3.3 Implementar DAOs e repositórios concretos Drift
    - Criar `produto_dao.dart`, `registro_dao.dart`, `mercado_dao.dart`, `lista_dao.dart` com queries type-safe
    - Criar `drift_produto_repository.dart`, `drift_registro_repository.dart`, `drift_mercado_repository.dart`, `drift_lista_repository.dart` implementando as interfaces
    - Capturar exceções do Drift e relançar como `AppError.falhaAoSalvar/Ler/Excluir`
    - _Requisitos: 1.4, 1.7, 1.8, 1.9, 2.5, 3.1, 3.8, 3.9, 4.1, 4.10, 4.12, 7.1, 7.3_

  - [ ]* 3.4 Escrever teste de propriedade para round-trip de serialização (Property 1)
    - **Property 1: Round-trip de serialização de entidades**
    - Criar implementações in-memory dos repositórios para testes
    - Gerar instâncias aleatórias de cada entidade com `faker`, salvar via DAO e recuperar
    - Verificar que o objeto recuperado é `==` ao original para Produto, RegistroDePreco, Mercado, ItemDeLista e ListaDeCompras (100 iterações cada)
    - Incluir comentário: `// Feature: modo-mercado, Property 1: Round-trip de serialização de entidades`
    - Arquivo: `test/infrastructure/drift_mapper_test.dart`
    - **Valida: Requisitos 3.10, 3.11, 7.4, 7.5, 7.6**

- [ ] 4. Checkpoint — Infraestrutura compila e Property 1 passa
  - Executar `flutter analyze` (zero warnings) e `flutter test test/infrastructure/`; perguntar ao usuário se houver dúvidas.


- [ ] 5. Use cases de Produto
  - [ ] 5.1 Implementar use cases de Produto
    - Criar `cadastrar_produto_use_case.dart`: validar nome, categoria e unidade não-vazios (lançar `AppError.campoObrigatorioAusente`), gerar UUID, persistir via repositório
    - Criar `editar_produto_use_case.dart`: mesmas validações do cadastro, atualizar `atualizadoEm`
    - Criar `excluir_produto_use_case.dart`: verificar `possuiRegistros` antes de excluir, lançar `AppError.produtoPossuiRegistros` se necessário
    - Criar `listar_produtos_use_case.dart`: retornar lista ordenada alfabeticamente (case-insensitive) com suporte a filtro por termo de busca
    - _Requisitos: 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 1.10_

  - [ ]* 5.2 Escrever teste de propriedade para validação de campos obrigatórios (Property 2)
    - **Property 2: Validação de campos obrigatórios do Produto**
    - Gerar combinações arbitrárias onde nome, categoria ou unidade estão ausentes/em branco (incluindo strings só de espaços)
    - Verificar que `CadastrarProdutoUseCase` e `EditarProdutoUseCase` lançam `AppError.campoObrigatorioAusente` e não persistem dados (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 2: Validação de campos obrigatórios do Produto`
    - Arquivo: `test/features/produtos/cadastrar_produto_use_case_test.dart`
    - **Valida: Requisitos 1.2, 1.3, 1.6**

  - [ ]* 5.3 Escrever teste de propriedade para ordenação alfabética (Property 9)
    - **Property 9: Ordenação alfabética da lista de produtos**
    - Gerar conjuntos arbitrários de produtos com nomes aleatórios; verificar que `ListarProdutosUseCase` retorna lista ordenada lexicograficamente (case-insensitive) (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 9: Ordenação alfabética da lista de produtos`
    - Arquivo: `test/features/produtos/listar_produtos_use_case_test.dart`
    - **Valida: Requisito 1.7**

  - [ ]* 5.4 Escrever teste de propriedade para filtragem por busca (Property 10)
    - **Property 10: Filtragem de produtos por busca**
    - Gerar conjuntos arbitrários de produtos e termos de busca; verificar que todos os retornados contêm o termo (case-insensitive) e nenhum que não satisfaz o critério aparece (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 10: Filtragem de produtos por busca`
    - Arquivo: `test/features/produtos/listar_produtos_use_case_test.dart`
    - **Valida: Requisito 1.8**


- [ ] 6. Use cases de Registro de Preço
  - [ ] 6.1 Implementar use cases de Registro
    - Criar `registrar_preco_use_case.dart`: validar produto, mercado e `valorCentavos > 0` (lançar `AppError.valorInvalido` ou `AppError.campoObrigatorioAusente`), gerar UUID, persistir registro
    - Criar `listar_registros_use_case.dart`: retornar registros de um produto ordenados do mais recente ao mais antigo
    - _Requisitos: 2.2, 2.3, 2.4, 2.5, 3.1_

  - [ ]* 6.2 Escrever teste de propriedade para validação de valor positivo (Property 3)
    - **Property 3: Validação de valor positivo no Registro de Preço**
    - Gerar combinações arbitrárias com `valorCentavos ≤ 0` ou campos ausentes; verificar que `RegistrarPrecoUseCase` rejeita e não persiste (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 3: Validação de valor positivo no Registro de Preço`
    - Arquivo: `test/features/registros/registrar_preco_use_case_test.dart`
    - **Valida: Requisitos 2.2, 2.3, 2.4**

- [ ] 7. Use cases de Histórico de Preços
  - [ ] 7.1 Implementar `CalcularMetricasUseCase`
    - Calcular `menorPrecoCentavos`, `maiorPrecoCentavos` e `mediaPrecoCentavos` a partir dos registros
    - Suportar filtro por `mercadoId` e por `DateTimeRange`
    - Retornar registros ordenados do mais recente ao mais antigo
    - _Requisitos: 3.1, 3.2, 3.3, 3.4, 3.6, 3.7, 3.8, 3.9_

  - [ ]* 7.2 Escrever teste de propriedade para ordenação do histórico (Property 4)
    - **Property 4: Ordenação do histórico**
    - Gerar conjuntos arbitrários de registros em ordem aleatória; verificar que o resultado está sempre em ordem decrescente de data (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 4: Ordenação do histórico`
    - Arquivo: `test/features/historico/calcular_metricas_use_case_test.dart`
    - **Valida: Requisito 3.1**

  - [ ]* 7.3 Escrever teste de propriedade para corretude das métricas (Property 5)
    - **Property 5: Corretude das métricas do histórico**
    - Gerar conjuntos não-vazios de registros; verificar que `menorPreco ≤ mediaPreco ≤ maiorPreco` e que menor/maior são valores efetivamente presentes no conjunto (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 5: Corretude das métricas do histórico`
    - Arquivo: `test/features/historico/calcular_metricas_use_case_test.dart`
    - **Valida: Requisitos 3.2, 3.3, 3.4, 3.6**

  - [ ]* 7.4 Escrever teste de propriedade para filtragem do histórico (Property 11)
    - **Property 11: Filtragem do histórico por mercado e período**
    - Gerar conjuntos arbitrários de registros com filtros de mercado e/ou período; verificar que todos os retornados satisfazem os critérios e nenhum fora dos critérios aparece (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 11: Filtragem do histórico por mercado e período`
    - Arquivo: `test/features/historico/calcular_metricas_use_case_test.dart`
    - **Valida: Requisitos 3.8, 3.9**


- [ ] 8. Use cases de Lista de Compras
  - [ ] 8.1 Implementar use cases de Lista de Compras
    - Criar `criar_lista_use_case.dart`: validar nome não-vazio, gerar UUID, persistir lista
    - Criar `adicionar_item_use_case.dart`: verificar que produto possui ao menos um registro (lançar `AppError.produtoSemPreco` caso contrário), capturar `ultimoPrecoRegistradoCentavos` no momento da adição, persistir item
    - Criar `calcular_total_use_case.dart`: somar `subtotalEstimadoCentavos` de todos os itens com `ultimoPrecoRegistradoCentavos` não-nulo
    - _Requisitos: 4.1, 4.2, 4.3, 4.7, 4.8_

  - [ ]* 8.2 Escrever teste de propriedade para total da lista de compras (Property 7)
    - **Property 7: Estimativa de total da lista de compras**
    - Gerar listas arbitrárias com itens com e sem `ultimoPrecoRegistradoCentavos`; verificar que `totalEstimadoCentavos == soma((preco * quantidade).round())` apenas para itens com preço não-nulo (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 7: Estimativa de total da lista de compras`
    - Arquivo: `test/features/lista_de_compras/calcular_total_use_case_test.dart`
    - **Valida: Requisito 4.7**

  - [ ]* 8.3 Escrever teste de propriedade para restrição de produto sem preço (Property 8)
    - **Property 8: Restrição de produto sem preço na lista**
    - Gerar produtos sem registros de preço e tentar adicioná-los; verificar que `AdicionarItemUseCase` lança `AppError.produtoSemPreco` e a lista permanece inalterada (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 8: Restrição de produto sem preço na lista`
    - Arquivo: `test/features/lista_de_compras/adicionar_item_use_case_test.dart`
    - **Valida: Requisitos 4.2, 4.3, 4.8**

- [ ] 9. Use cases de Comparação Entre Mercados
  - [ ] 9.1 Implementar `CompararMercadosUseCase`
    - Para cada mercado com registro do produto, buscar o registro mais recente via `ultimoPreco(produtoId, mercadoId)`
    - Retornar lista de `ComparacaoMercado` ordenada do menor para o maior `ultimoPrecoCentavos`
    - Marcar `eMenorPreco = true` apenas no primeiro item da lista
    - _Requisitos: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

  - [ ]* 9.2 Escrever teste de propriedade para corretude da comparação (Property 6)
    - **Property 6: Corretude da comparação entre mercados**
    - Gerar produtos com registros em N mercados distintos; verificar que o resultado tem exatamente N itens, cada um com o preço mais recente, ordenados do menor ao maior, e exatamente um com `eMenorPreco = true` (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 6: Corretude da comparação entre mercados`
    - Arquivo: `test/features/comparacao/comparar_mercados_use_case_test.dart`
    - **Valida: Requisitos 6.1, 6.2, 6.3, 6.6**

- [ ] 10. Use cases de Dashboard
  - [ ] 10.1 Implementar `CalcularDashboardUseCase`
    - Calcular `totalMesCentavos` somando `valorCentavos` dos registros com data no mês corrente
    - Calcular top 3 categorias por soma de gastos no mês
    - Calcular top 3 produtos com maior percentual de aumento (mês atual vs. mês anterior)
    - Calcular `economiaEstimadaCentavos` (diferença entre maior preço e preço pago por produto no mês, somada; sempre ≥ 0)
    - Retornar `DashboardData` com `temDados = false` quando não há registros no mês
    - _Requisitos: 5.1, 5.2, 5.3, 5.4, 5.5_

  - [ ]* 10.2 Escrever teste de propriedade para invariantes do Dashboard (Property 12)
    - **Property 12: Invariantes do Dashboard**
    - Gerar conjuntos arbitrários de registros; verificar: (a) total do mês = soma dos registros do mês corrente; (b) economia estimada ≥ 0; (c) top 3 categorias têm soma ≥ qualquer outra categoria não listada (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 12: Invariantes do Dashboard`
    - Arquivo: `test/features/dashboard/calcular_dashboard_use_case_test.dart`
    - **Valida: Requisitos 5.1, 5.2, 5.4**

  - [ ]* 10.3 Escrever teste de propriedade para reatividade do Dashboard (Property 13)
    - **Property 13: Reatividade do Dashboard após novo registro**
    - Gerar estado arbitrário do Dashboard e novo registro com data no mês corrente; verificar que total recalculado = total anterior + `valorCentavos` do novo registro (100 iterações)
    - Incluir comentário: `// Feature: modo-mercado, Property 13: Reatividade do Dashboard após novo registro`
    - Arquivo: `test/features/dashboard/calcular_dashboard_use_case_test.dart`
    - **Valida: Requisito 5.8**

- [ ] 11. Checkpoint — Use cases e testes de propriedade
  - Executar `flutter test test/features/`; garantir que todos os testes passam; perguntar ao usuário se houver dúvidas.


- [ ] 12. Presentation layer — Produtos e Registros
  - [ ] 12.1 Implementar `ProdutosNotifier` e views de Produto
    - Criar `produtos_notifier.dart` com `AsyncNotifier` (Riverpod), expondo lista de produtos, estado de busca e tratamento de erros via `AsyncValue`
    - Criar `produtos_list_view.dart` com `SearchBar`, lista ordenada e botão de novo produto
    - Criar `produto_form_view.dart` com campos validados inline (destaque vermelho em campo inválido) e `AlertDialog` de confirmação para exclusão com registros vinculados
    - _Requisitos: 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 1.8, 1.9, 1.10_

  - [ ] 12.2 Implementar `RegistroNotifier` e `RegistroFormView`
    - Criar `registro_notifier.dart` com `AsyncNotifier`, pré-preenchimento de data atual, seleção de produto/mercado e tratamento de erros
    - Criar `registro_form_view.dart` com campos de produto, valor (input em reais, convertido para centavos via `MoneyFormatter`), mercado, data e foto opcional
    - Suportar criação de novo mercado inline no formulário via `AlertDialog`
    - Implementar seleção e armazenamento local de foto via `image_picker`
    - _Requisitos: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10_

- [ ] 13. Presentation layer — Histórico e Comparação
  - [ ] 13.1 Implementar `HistoricoNotifier`, `HistoricoView` e `PrecoChartView`
    - Criar `historico_notifier.dart` com `AsyncNotifier`, expondo métricas, registros filtrados e estado de filtros
    - Criar `historico_view.dart` com lista de registros, cards de métricas (menor, maior, média em reais) e controles de filtro por mercado e período
    - Criar `preco_chart_view.dart` usando `fl_chart` com `LineChart` (eixo X = data, eixo Y = valor em reais); exibir ponto único quando há apenas um registro; ocultar métricas quando não há registros
    - _Requisitos: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9_

  - [ ] 13.2 Implementar `ComparacaoNotifier` e `ComparacaoView`
    - Criar `comparacao_notifier.dart` com `AsyncNotifier`
    - Criar `comparacao_view.dart` com lista de mercados ordenada por preço, destaque visual no menor preço (ex: ícone de troféu ou cor diferente), data do último registro por mercado, e mensagens para produto sem registros ou com apenas um mercado
    - _Requisitos: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7_

- [ ] 14. Presentation layer — Lista de Compras e Dashboard
  - [ ] 14.1 Implementar `ListaNotifier`, `ListasView` e `ListaDetalheView`
    - Criar `lista_notifier.dart` com `AsyncNotifier`, expondo listas, total estimado e estado de erro
    - Criar `listas_view.dart` com lista de listas de compras e botão de nova lista; `AlertDialog` de confirmação antes de excluir
    - Criar `lista_detalhe_view.dart` com itens agrupados por categoria, checkbox de conclusão (distinção visual para itens concluídos), total estimado em reais e botão de adicionar item
    - _Requisitos: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.9, 4.10, 4.11, 4.12_

  - [ ] 14.2 Implementar `DashboardNotifier` e `DashboardView`
    - Criar `dashboard_notifier.dart` com `AsyncNotifier`; recalcular dados automaticamente via `ref.watch` nos providers de registros
    - Criar `dashboard_view.dart` com card de total do mês, lista de top categorias (navegável para detalhe), lista de produtos com maior aumento (navegável para histórico), card de economia estimada e estado vazio com mensagem orientativa
    - _Requisitos: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8_

- [ ] 15. Checkpoint — Presentation layer compila e widgets renderizam
  - Executar `flutter analyze` (zero warnings) e `flutter test test/features/` (incluindo widget tests); perguntar ao usuário se houver dúvidas.


- [ ] 16. Integração, navegação e wiring final
  - [ ] 16.1 Configurar GoRouter com todas as rotas
    - Criar `router.dart` com todas as rotas: `/`, `/produtos`, `/produtos/novo`, `/produtos/:id/editar`, `/produtos/:id/historico`, `/produtos/:id/comparacao`, `/registros/novo`, `/listas`, `/listas/:id`
    - Criar `app.dart` com `MaterialApp.router` usando o GoRouter configurado
    - Criar `main.dart` com `ProviderScope` e inicialização do banco Drift
    - _Requisitos: 1.1, 2.1, 3.1, 4.1, 5.1, 6.7_

  - [ ] 16.2 Wiring de injeção de dependência via Riverpod
    - Criar providers para `AppDatabase`, repositórios concretos e use cases em `lib/infrastructure/providers.dart`
    - Injetar use cases nos notifiers via `ref.watch`
    - Garantir que os providers de repositório podem ser sobrescritos em testes com implementações in-memory
    - _Requisitos: 7.1, 7.2_

  - [ ] 16.3 Conectar fluxo de navegação Histórico → Comparação → Registro
    - Conectar botão de comparação no `HistoricoView` para `ComparacaoView` via GoRouter
    - Conectar botão de novo registro no `HistoricoView` para `RegistroFormView` pré-preenchido com o produto
    - _Requisitos: 3.5, 6.7_

  - [ ]* 16.4 Escrever testes de integração para fluxos críticos
    - Fluxo 1: Cadastrar produto → registrar preço → visualizar histórico (verificar métricas corretas)
    - Fluxo 2: Criar lista de compras → adicionar itens → marcar como concluído (verificar total estimado)
    - Fluxo 3: Acessar dashboard → navegar para histórico de produto (verificar dados do mês)
    - Usar banco Drift in-memory para isolar os testes
    - Arquivo: `test/integration/`
    - _Requisitos: 1.4, 2.5, 3.1, 4.5, 5.7_

- [ ] 17. Checkpoint final — Todos os testes passam e CI está verde
  - Executar `flutter analyze` (zero warnings), `flutter test --coverage` (todas as suites), verificar que o job `test` do GitHub Actions passa; perguntar ao usuário se houver dúvidas.

---

## Notes

- Tarefas marcadas com `*` são opcionais e podem ser puladas para um MVP mais rápido
- Cada tarefa referencia requisitos específicos para rastreabilidade
- Os checkpoints garantem validação incremental a cada conjunto de features
- Os testes de propriedade (flutter_test + faker) validam invariantes universais com 100 iterações cada
- Os testes de exemplo (flutter_test) validam cenários específicos e casos de borda
- Valores monetários são sempre `int` (centavos) — nunca `double` para dinheiro
- O banco Drift in-memory (`NativeDatabase.memory()`) permite rodar todos os testes no Linux sem emulador
- O `.ipa` gerado com `--no-codesign` é re-assinado localmente com AltStore/Sideloadly antes de instalar no iPhone

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2", "1.3"] },
    { "id": 1, "tasks": ["2.1", "2.2", "2.3"] },
    { "id": 2, "tasks": ["3.1", "3.2"] },
    { "id": 3, "tasks": ["3.3"] },
    { "id": 4, "tasks": ["3.4"] },
    { "id": 5, "tasks": ["5.1", "6.1", "7.1", "8.1", "9.1", "10.1"] },
    { "id": 6, "tasks": ["5.2", "5.3", "5.4", "6.2", "7.2", "7.3", "7.4", "8.2", "8.3", "9.2", "10.2", "10.3"] },
    { "id": 7, "tasks": ["12.1", "12.2", "13.1", "13.2", "14.1", "14.2"] },
    { "id": 8, "tasks": ["16.1", "16.2"] },
    { "id": 9, "tasks": ["16.3"] },
    { "id": 10, "tasks": ["16.4"] }
  ]
}
```
