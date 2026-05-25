# Design Document — Modo Mercado

## Overview

O Modo Mercado é um aplicativo móvel que permite ao usuário registrar, acompanhar e comparar preços de produtos do dia a dia. O MVP opera 100% offline, sem dependência de backend ou conectividade de rede.

### Objetivos de Design

- **Simplicidade de uso**: fluxos com o mínimo de interações para registrar um preço
- **Confiabilidade dos dados**: persistência local robusta com integridade garantida
- **Desempenho**: listas e gráficos responsivos mesmo com centenas de registros
- **Testabilidade**: toda a lógica de negócio testável em Linux sem emulador
- **Extensibilidade**: arquitetura que suporte futuras funcionalidades (OCR, sync, IA)

### Escopo do MVP

| Módulo | Descrição |
|---|---|
| Cadastro de Produto | CRUD de produtos com validação |
| Registro de Preço | Entrada de preços com foto opcional |
| Histórico de Preços | Visualização temporal com métricas e gráfico |
| Lista de Compras | Planejamento de compras com estimativa de custo |
| Dashboard | Resumo financeiro mensal |
| Comparação Entre Mercados | Ranking de preços por mercado |
| Persistência | SQLite local via Drift com serialização round-trip |

### Stack Técnica

| Camada | Tecnologia | Justificativa |
|---|---|---|
| UI | Flutter 3.x + Dart | Cross-platform, testável no Linux |
| Estado | Riverpod 2.x | Injeção de dependência + reatividade sem BuildContext |
| Persistência | Drift (SQLite) | Type-safe, testável in-memory no Linux |
| Gráficos | fl_chart | Gráfico de linha para histórico de preços |
| Testes | flutter_test + faker | Unit, widget e property-based tests |
| Navegação | GoRouter | Rotas declarativas e deep linking |
| Igualdade | equatable | `==` e `hashCode` sem boilerplate |
| CI/CD | GitHub Actions | Pipeline test (Linux) + build IPA (macOS) |

---

## Architecture

### Padrão Arquitetural: Clean Architecture + Feature-First

A aplicação segue Clean Architecture com separação em três camadas, organizada por feature (módulo funcional).

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│         Flutter Widgets + Riverpod Notifiers             │
├─────────────────────────────────────────────────────────┤
│                      Domain Layer                        │
│          Use Cases + Domain Models + Interfaces          │
├─────────────────────────────────────────────────────────┤
│                   Infrastructure Layer                   │
│        Drift DAOs + Repositórios Concretos               │
└─────────────────────────────────────────────────────────┘
```

### Estrutura de Diretórios

```
lib/
├── main.dart                          # Entry point, ProviderScope
├── app/
│   ├── app.dart                       # MaterialApp + GoRouter
│   └── router.dart                    # Rotas tipadas com GoRouter
│
├── core/
│   ├── domain/
│   │   ├── models/
│   │   │   ├── produto.dart
│   │   │   ├── registro_de_preco.dart
│   │   │   ├── mercado.dart
│   │   │   ├── lista_de_compras.dart
│   │   │   └── item_de_lista.dart
│   │   └── errors/
│   │       └── app_error.dart
│   ├── protocols/
│   │   ├── produto_repository.dart
│   │   ├── registro_repository.dart
│   │   ├── mercado_repository.dart
│   │   └── lista_repository.dart
│   └── formatters/
│       └── money_formatter.dart       # Conversão int (centavos) ↔ String
│
├── features/
│   ├── produtos/
│   │   ├── domain/use_cases/
│   │   │   ├── cadastrar_produto_use_case.dart
│   │   │   ├── editar_produto_use_case.dart
│   │   │   ├── excluir_produto_use_case.dart
│   │   │   └── listar_produtos_use_case.dart
│   │   ├── data/
│   │   │   └── drift_produto_repository.dart
│   │   └── presentation/
│   │       ├── produtos_list_view.dart
│   │       ├── produto_form_view.dart
│   │       └── produtos_notifier.dart
│   ├── registros/
│   │   ├── domain/use_cases/
│   │   │   ├── registrar_preco_use_case.dart
│   │   │   └── listar_registros_use_case.dart
│   │   ├── data/
│   │   │   └── drift_registro_repository.dart
│   │   └── presentation/
│   │       ├── registro_form_view.dart
│   │       └── registro_notifier.dart
│   ├── historico/
│   │   ├── domain/use_cases/
│   │   │   └── calcular_metricas_use_case.dart
│   │   └── presentation/
│   │       ├── historico_view.dart
│   │       ├── preco_chart_view.dart
│   │       └── historico_notifier.dart
│   ├── lista_de_compras/
│   │   ├── domain/use_cases/
│   │   │   ├── criar_lista_use_case.dart
│   │   │   ├── adicionar_item_use_case.dart
│   │   │   └── calcular_total_use_case.dart
│   │   ├── data/
│   │   │   └── drift_lista_repository.dart
│   │   └── presentation/
│   │       ├── listas_view.dart
│   │       ├── lista_detalhe_view.dart
│   │       └── lista_notifier.dart
│   ├── dashboard/
│   │   ├── domain/use_cases/
│   │   │   └── calcular_dashboard_use_case.dart
│   │   └── presentation/
│   │       ├── dashboard_view.dart
│   │       └── dashboard_notifier.dart
│   └── comparacao/
│       ├── domain/use_cases/
│       │   └── comparar_mercados_use_case.dart
│       └── presentation/
│           ├── comparacao_view.dart
│           └── comparacao_notifier.dart
│
└── infrastructure/
    ├── database/
    │   ├── app_database.dart          # Drift AppDatabase
    │   ├── tables/
    │   │   ├── produtos_table.dart
    │   │   ├── registros_table.dart
    │   │   ├── mercados_table.dart
    │   │   ├── listas_table.dart
    │   │   └── itens_table.dart
    │   └── daos/
    │       ├── produto_dao.dart
    │       ├── registro_dao.dart
    │       ├── mercado_dao.dart
    │       └── lista_dao.dart
    └── repositories/
        ├── drift_produto_repository.dart
        ├── drift_registro_repository.dart
        ├── drift_mercado_repository.dart
        └── drift_lista_repository.dart
```

### Decisões Arquiteturais

**Drift como camada de persistência**
Drift (antes moor) oferece API type-safe sobre SQLite, geração de código via `build_runner`, e suporte a banco in-memory para testes — o que permite rodar toda a suite de testes no Linux sem emulador iOS.

**Valores monetários como `int` (centavos)**
`double` tem imprecisão de ponto flutuante (`0.1 + 0.2 != 0.3` em Dart). Armazenar como centavos inteiros elimina esse problema completamente. O `MoneyFormatter` converte centavos para exibição (`R$ 12,50`) e faz o parse do input do usuário.

**Riverpod 2.x para estado e injeção de dependência**
Riverpod permite injeção de dependência sem `BuildContext`, facilitando testes de use cases e notifiers sem precisar de widget tree. Os repositórios concretos são providos via `Provider` e sobrescritos em testes com implementações in-memory.

**GoRouter para navegação**
Rotas declarativas com suporte a deep linking e navegação programática sem `BuildContext`. Cada rota é tipada e testável isoladamente.

---

## Components and Interfaces

### Interfaces de Repositório (Abstract Classes)

```dart
abstract class ProdutoRepository {
  Future<List<Produto>> listar();
  Future<List<Produto>> buscar(String termo);
  Future<void> salvar(Produto produto);
  Future<void> atualizar(Produto produto);
  Future<void> excluir(String id);
  Future<bool> possuiRegistros(String produtoId);
}

abstract class RegistroRepository {
  Future<List<RegistroDePreco>> listarPorProduto(String produtoId);
  Future<List<RegistroDePreco>> listarPorMercado(String mercadoId);
  Future<List<RegistroDePreco>> listarPorPeriodo(DateTime inicio, DateTime fim);
  Future<void> salvar(RegistroDePreco registro);
  Future<void> excluir(String id);
  Future<RegistroDePreco?> ultimoPreco(String produtoId, String mercadoId);
}

abstract class MercadoRepository {
  Future<List<Mercado>> listar();
  Future<void> salvar(Mercado mercado);
  Future<void> excluir(String id);
}

abstract class ListaRepository {
  Future<List<ListaDeCompras>> listar();
  Future<void> salvar(ListaDeCompras lista);
  Future<void> atualizar(ListaDeCompras lista);
  Future<void> excluir(String id);
}
```

### Use Cases Principais

```dart
// Cadastro de Produto
class CadastrarProdutoUseCase {
  final ProdutoRepository repository;
  Future<Produto> executar({
    required String nome,
    required String categoria,
    required String unidade,
    String? marca,
    double? quantidade,
    String? observacao,
  });
  // Lança AppError.campoObrigatorioAusente se nome, categoria ou unidade estiverem vazios
}

// Cálculo de Métricas do Histórico
class CalcularMetricasUseCase {
  Future<MetricasHistorico> executar({
    required String produtoId,
    String? filtroMercadoId,
    DateTimeRange? periodo,
  });
}

// Cálculo do Dashboard
class CalcularDashboardUseCase {
  Future<DashboardData> executar(DateTime mes);
}

// Comparação Entre Mercados
class CompararMercadosUseCase {
  Future<List<ComparacaoMercado>> executar(String produtoId);
}
```

### MoneyFormatter (Serialização Monetária)

```dart
class MoneyFormatter {
  /// Converte centavos (int) para string de exibição: 1250 → "R$ 12,50"
  String format(int centavos);

  /// Faz parse do input do usuário para centavos: "12,50" → 1250
  /// Lança AppError.valorInvalido se o input não for um número positivo válido
  int parse(String input);
}
```

### Navegação (GoRouter)

```dart
// Rotas definidas em router.dart
const routes = [
  GoRoute(path: '/',              builder: DashboardView),
  GoRoute(path: '/produtos',      builder: ProdutosListView),
  GoRoute(path: '/produtos/novo', builder: ProdutoFormView),
  GoRoute(path: '/produtos/:id/editar',    builder: ProdutoFormView),
  GoRoute(path: '/produtos/:id/historico', builder: HistoricoView),
  GoRoute(path: '/produtos/:id/comparacao', builder: ComparacaoView),
  GoRoute(path: '/registros/novo', builder: RegistroFormView),
  GoRoute(path: '/listas',         builder: ListasView),
  GoRoute(path: '/listas/:id',     builder: ListaDetalheView),
];
```

### Fluxo de Navegação

```
BottomNavigationBar
├── Dashboard (/)
│   ├── → HistoricoView (/produtos/:id/historico)
│   └── → CategoriaDetalheView
│
├── Produtos (/produtos)
│   ├── → ProdutoFormView (/produtos/novo | /produtos/:id/editar)
│   └── → HistoricoView (/produtos/:id/historico)
│       ├── → ComparacaoView (/produtos/:id/comparacao)
│       └── → RegistroFormView (/registros/novo)
│
├── Registros (/registros/novo)  [acesso rápido]
│
└── Listas (/listas)
    └── → ListaDetalheView (/listas/:id)
        └── → ProdutosListView (seleção de produto)
```

---

## Data Models

### Modelos de Domínio (Classes Imutáveis com Equatable)

```dart
class Produto extends Equatable {
  final String id;          // UUID v4
  final String nome;
  final String categoria;
  final String unidade;
  final String? marca;
  final double? quantidade;
  final String? observacao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  @override
  List<Object?> get props => [id, nome, categoria, unidade, marca,
                               quantidade, observacao, criadoEm, atualizadoEm];
}

class RegistroDePreco extends Equatable {
  final String id;
  final String produtoId;
  final String mercadoId;
  final int valorCentavos;   // Armazenado como centavos (int) para evitar imprecisão
  final DateTime data;
  final String? fotoPath;    // Caminho local da imagem
  final DateTime criadoEm;

  @override
  List<Object?> get props => [id, produtoId, mercadoId, valorCentavos,
                               data, fotoPath, criadoEm];
}

class Mercado extends Equatable {
  final String id;
  final String nome;
  final DateTime criadoEm;

  @override
  List<Object?> get props => [id, nome, criadoEm];
}

class ListaDeCompras extends Equatable {
  final String id;
  final String nome;
  final List<ItemDeLista> itens;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  int get totalEstimadoCentavos =>
      itens.fold(0, (acc, item) => acc + item.subtotalEstimadoCentavos);

  @override
  List<Object?> get props => [id, nome, itens, criadoEm, atualizadoEm];
}

class ItemDeLista extends Equatable {
  final String id;
  final String produtoId;
  final double quantidade;
  final bool concluido;
  final int? ultimoPrecoRegistradoCentavos;  // snapshot no momento da adição

  int get subtotalEstimadoCentavos {
    final preco = ultimoPrecoRegistradoCentavos;
    if (preco == null) return 0;
    return (preco * quantidade).round();
  }

  @override
  List<Object?> get props => [id, produtoId, quantidade, concluido,
                               ultimoPrecoRegistradoCentavos];
}
```

### Modelos de Resultado (Use Cases)

```dart
class MetricasHistorico {
  final int? menorPrecoCentavos;
  final int? maiorPrecoCentavos;
  final int? mediaPrecoCentavos;
  final List<RegistroDePreco> registros;  // ordenados do mais recente ao mais antigo
}

class DashboardData {
  final int totalMesCentavos;
  final List<CategoriaGasto> topCategorias;          // top 3
  final List<ProdutoAumento> produtosComMaiorAumento; // top 3
  final int economiaEstimadaCentavos;
  final bool temDados;
}

class CategoriaGasto {
  final String categoria;
  final int totalGastoCentavos;
}

class ProdutoAumento {
  final Produto produto;
  final double percentualAumento;
}

class ComparacaoMercado {
  final Mercado mercado;
  final int ultimoPrecoCentavos;
  final DateTime dataUltimoRegistro;
  final bool eMenorPreco;
}
```

### Tabelas Drift (SQLite)

```dart
// Definição das tabelas — Drift gera o código de acesso via build_runner

class Produtos extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get categoria => text()();
  TextColumn get unidade => text()();
  TextColumn get marca => text().nullable()();
  RealColumn get quantidade => real().nullable()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class RegistrosDePreco extends Table {
  TextColumn get id => text()();
  TextColumn get produtoId => text().references(Produtos, #id)();
  TextColumn get mercadoId => text().references(Mercados, #id)();
  IntColumn get valorCentavos => integer()();  // INTEGER — sem imprecisão
  DateTimeColumn get data => dateTime()();
  TextColumn get fotoPath => text().nullable()();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Mercados extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ListasDeCompras extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ItensDeLista extends Table {
  TextColumn get id => text()();
  TextColumn get listaId => text().references(ListasDeCompras, #id)();
  TextColumn get produtoId => text()();
  RealColumn get quantidade => real()();
  BoolColumn get concluido => boolean().withDefault(const Constant(false))();
  IntColumn get ultimoPrecoRegistradoCentavos => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Diagrama de Relacionamentos

```
Produto (1) ──────────── (N) RegistroDePreco
    │                              │
    │                              │
    └── referenciado por ──── ItemDeLista (N) ──── (1) ListaDeCompras

Mercado (1) ──────────── (N) RegistroDePreco
```

Regras de deleção:
- `Produto` deletado → `RegistroDePreco` em cascade
- `ListaDeCompras` deletada → `ItemDeLista` em cascade
- `Mercado` deletado → `RegistroDePreco.mercadoId` set null (registro preservado)

---

## Correctness Properties

*Uma propriedade é uma característica ou comportamento que deve ser verdadeiro em todas as execuções válidas de um sistema — essencialmente, uma declaração formal sobre o que o sistema deve fazer. Propriedades servem como ponte entre especificações legíveis por humanos e garantias de corretude verificáveis por máquina.*

### Property 1: Round-trip de serialização de entidades

*Para qualquer* entidade válida (Produto, RegistroDePreco, Mercado, ItemDeLista, ListaDeCompras), converter a entidade para a representação de linha do banco Drift e depois converter de volta para o modelo de domínio SHALL produzir um objeto equivalente ao original — todos os campos devem ter os mesmos valores, incluindo `valorCentavos` armazenado como `int`.

**Validates: Requirements 3.10, 3.11, 7.4, 7.5, 7.6**

---

### Property 2: Validação de campos obrigatórios do Produto

*Para qualquer* combinação de entradas onde nome, categoria ou unidade estejam ausentes ou compostos apenas de espaços em branco, o use case de cadastro e edição SHALL rejeitar a operação, lançar um `AppError.campoObrigatorioAusente` identificando o campo correto, e não persistir nenhum dado.

**Validates: Requirements 1.2, 1.3, 1.6**

---

### Property 3: Validação de valor positivo no Registro de Preço

*Para qualquer* combinação de entradas no formulário de Registro_de_Preco onde o valor em centavos seja menor ou igual a zero, ou onde produto ou mercado estejam ausentes, o use case SHALL rejeitar a operação e não persistir nenhum registro.

**Validates: Requirements 2.2, 2.3, 2.4**

---

### Property 4: Ordenação do histórico

*Para qualquer* conjunto de Registros_de_Preco de um Produto, a lista retornada pelo use case de histórico SHALL estar ordenada do registro mais recente para o mais antigo (ordem decrescente de data), independentemente da ordem em que os registros foram inseridos.

**Validates: Requirements 3.1**

---

### Property 5: Corretude das métricas do histórico

*Para qualquer* conjunto não-vazio de Registros_de_Preco de um Produto, as métricas calculadas SHALL satisfazer: `menorPreco ≤ mediaPreco ≤ maiorPreco`, e `menorPreco` e `maiorPreco` devem ser valores efetivamente presentes no conjunto de registros.

**Validates: Requirements 3.2, 3.3, 3.4, 3.6**

---

### Property 6: Corretude da comparação entre mercados

*Para qualquer* Produto com Registros_de_Preco em N mercados distintos, o use case de comparação SHALL retornar exatamente N itens (um por mercado), cada item com o preço do registro mais recente daquele mercado, a lista ordenada do menor para o maior preço, e exatamente um item com `eMenorPreco = true` (o primeiro da lista).

**Validates: Requirements 6.1, 6.2, 6.3, 6.6**

---

### Property 7: Estimativa de total da lista de compras

*Para qualquer* ListaDeCompras com N itens (incluindo itens com `concluido = true`), o `totalEstimadoCentavos` SHALL ser igual à soma de `(ultimoPrecoRegistradoCentavos × quantidade).round()` para cada ItemDeLista que possua `ultimoPrecoRegistradoCentavos` não-nulo.

**Validates: Requirements 4.7**

---

### Property 8: Restrição de produto sem preço na lista

*Para qualquer* Produto que não possua nenhum RegistroDePreco, a tentativa de adicioná-lo a uma ListaDeCompras SHALL ser rejeitada pelo use case com `AppError.produtoSemPreco`, e a lista SHALL permanecer inalterada.

**Validates: Requirements 4.2, 4.3, 4.8**

---

### Property 9: Ordenação alfabética da lista de produtos

*Para qualquer* conjunto de Produtos cadastrados, a lista retornada pelo use case de listagem SHALL estar ordenada alfabeticamente por nome (ordem lexicográfica crescente, case-insensitive).

**Validates: Requirements 1.7**

---

### Property 10: Filtragem de produtos por busca

*Para qualquer* conjunto de Produtos e qualquer termo de busca não-vazio, todos os Produtos retornados pelo use case de busca SHALL conter o termo buscado no nome ou na categoria (comparação case-insensitive), e nenhum Produto que não satisfaça esse critério SHALL aparecer nos resultados.

**Validates: Requirements 1.8**

---

### Property 11: Filtragem do histórico por mercado e período

*Para qualquer* conjunto de Registros_de_Preco, filtro de mercado e/ou intervalo de datas aplicado, todos os registros retornados SHALL pertencer ao mercado filtrado (quando filtro de mercado aplicado) e ter data dentro do intervalo (quando filtro de período aplicado). Nenhum registro fora dos critérios SHALL aparecer nos resultados.

**Validates: Requirements 3.8, 3.9**

---

### Property 12: Invariantes do Dashboard

*Para qualquer* conjunto de Registros_de_Preco, os valores calculados pelo Dashboard SHALL satisfazer: (a) o total do mês é a soma dos `valorCentavos` de todos os registros com data no mês corrente; (b) a economia estimada é sempre ≥ 0; (c) as top 3 categorias têm soma de gastos maior ou igual a qualquer outra categoria não listada.

**Validates: Requirements 5.1, 5.2, 5.4**

---

### Property 13: Reatividade do Dashboard após novo registro

*Para qualquer* estado do Dashboard e qualquer novo RegistroDePreco adicionado com data no mês corrente, o total do mês recalculado SHALL ser igual ao total anterior somado ao `valorCentavos` do novo registro.

**Validates: Requirements 5.8**

---

## Error Handling

### Hierarquia de Erros (Sealed Class)

```dart
sealed class AppError implements Exception {
  const AppError();

  // Validação
  const factory AppError.campoObrigatorioAusente(String campo) = _CampoObrigatorio;
  const factory AppError.valorInvalido(String campo, String motivo) = _ValorInvalido;
  const factory AppError.produtoSemPreco(String nomeProduto) = _ProdutoSemPreco;

  // Persistência
  const factory AppError.falhaAoSalvar(String entidade, Object causa) = _FalhaAoSalvar;
  const factory AppError.falhaAoLer(String entidade, Object causa) = _FalhaAoLer;
  const factory AppError.falhaAoExcluir(String entidade, Object causa) = _FalhaAoExcluir;
  const factory AppError.dadosCorrempidos() = _DadosCorrempidos;

  // Negócio
  const factory AppError.produtoPossuiRegistros(String nomeProduto) = _ProdutoPossuiRegistros;
  const factory AppError.listaVazia() = _ListaVazia;

  String get mensagem;
  String? get sugestao;
}
```

### Estratégia de Tratamento

| Camada | Responsabilidade |
|---|---|
| Use Case | Valida regras de negócio, lança `AppError` semântico |
| Repository | Captura exceções do Drift, relança como `AppError.falhaAoSalvar/Ler/Excluir` |
| Notifier (Riverpod) | Captura erros, expõe `AsyncValue.error` ou `errorMessage: String?` |
| View | Exibe `SnackBar` ou `AlertDialog` com a mensagem do erro |

### Regras de Tratamento

1. **Erros de validação**: exibidos inline no formulário, campo destacado em vermelho
2. **Erros de persistência**: exibidos via `AlertDialog` com botão "OK"; estado em memória não é alterado
3. **Corrupção de dados**: ao inicializar o banco, se o Drift falhar, exibe alerta e inicia com estado vazio (conforme Requirement 7.7)
4. **Exclusão com dependências**: confirmação via `AlertDialog` destrutivo antes de prosseguir (Requirement 1.10, 4.11)

---

## Testing Strategy

### Abordagem Dual: Testes de Exemplo + Testes de Propriedade

A estratégia combina testes de exemplo (`flutter_test`) para comportamentos específicos e testes baseados em propriedades (geração manual com `faker` + `dart:math`) para verificar invariantes universais.

**Biblioteca de Property-Based Testing**: `flutter_test` + `faker` + `dart:math`
- Mínimo de 100 iterações por propriedade (loop `for (var i = 0; i < 100; i++)`)
- Cada teste de propriedade referencia a propriedade do design com o formato:
  `// Feature: modo-mercado, Property N: <texto da propriedade>`
- Repositórios substituídos por implementações in-memory nos testes de use case

### Testes de Propriedade

Cada propriedade do documento de design é implementada como um único teste:

| Propriedade | Teste | Arquivo |
|---|---|---|
| Property 1: Round-trip serialização | `testRoundTripSerializacao` | `drift_mapper_test.dart` |
| Property 2: Validação campos obrigatórios | `testValidacaoCamposObrigatoriosProduto` | `cadastrar_produto_use_case_test.dart` |
| Property 3: Validação valor positivo | `testValidacaoValorPositivoRegistro` | `registrar_preco_use_case_test.dart` |
| Property 4: Ordenação do histórico | `testOrdenacaoHistorico` | `calcular_metricas_use_case_test.dart` |
| Property 5: Corretude das métricas | `testCorretudeMétricas` | `calcular_metricas_use_case_test.dart` |
| Property 6: Corretude da comparação | `testCorretudeComparacao` | `comparar_mercados_use_case_test.dart` |
| Property 7: Total da lista | `testTotalListaDeCompras` | `calcular_total_use_case_test.dart` |
| Property 8: Restrição produto sem preço | `testRestricaoProdutoSemPreco` | `adicionar_item_use_case_test.dart` |
| Property 9: Ordenação alfabética | `testOrdenacaoAlfabeticaProdutos` | `listar_produtos_use_case_test.dart` |
| Property 10: Filtragem por busca | `testFiltragemProdutosPorBusca` | `listar_produtos_use_case_test.dart` |
| Property 11: Filtragem histórico | `testFiltragemHistoricoPorMercadoEPeriodo` | `calcular_metricas_use_case_test.dart` |
| Property 12: Invariantes do Dashboard | `testInvariantesDashboard` | `calcular_dashboard_use_case_test.dart` |
| Property 13: Reatividade do Dashboard | `testReatividadeDashboardAposNovoRegistro` | `calcular_dashboard_use_case_test.dart` |

### Exemplo de Teste de Propriedade

```dart
test('Property 4: histórico sempre ordenado do mais recente ao mais antigo', () {
  // Feature: modo-mercado, Property 4: Ordenação do histórico
  final random = Random();
  for (var i = 0; i < 100; i++) {
    final registros = gerarRegistrosAleatorios(random, count: random.nextInt(20) + 1);
    final resultado = calcularMetricasUseCase.executar(registros: registros);
    for (var j = 0; j < resultado.registros.length - 1; j++) {
      expect(
        resultado.registros[j].data.isAfter(resultado.registros[j + 1].data) ||
        resultado.registros[j].data.isAtSameMomentAs(resultado.registros[j + 1].data),
        isTrue,
      );
    }
  }
});
```

### Testes de Exemplo (flutter_test)

Focados em cenários específicos, integrações e casos de borda:

- **Formulários**: campos ausentes, valores limite, feedback visual de erro
- **Persistência**: salvar/recuperar com banco Drift in-memory
- **Dashboard**: cálculo com zero registros, cálculo com registros em meses diferentes
- **Navegação**: rotas GoRouter com parâmetros corretos
- **Foto**: anexar, armazenar e exibir imagem no registro de preço

### Testes de Widget

Fluxos críticos cobertos por testes de widget:

1. Cadastrar produto → registrar preço → visualizar histórico
2. Criar lista de compras → adicionar itens → marcar como concluído
3. Acessar dashboard → navegar para histórico de produto

### GitHub Actions Pipeline

```yaml
# .github/workflows/ci.yml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - flutter pub get
      - flutter analyze
      - flutter test --coverage

  build-ios:
    runs-on: macos-latest
    needs: test
    steps:
      - flutter pub get
      - flutter build ipa --no-codesign
      - upload-artifact: build/ios/ipa/*.ipa
```

### Cobertura Mínima Esperada

- Use Cases: 90%+
- Repositories (com Drift in-memory): 80%+
- Notifiers (Riverpod): 70%+
- Views: cobertura via testes de widget para fluxos críticos
