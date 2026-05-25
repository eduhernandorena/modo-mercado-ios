# Design — Modo Mercado Flutter + GitHub Actions

**Data:** 2026-05-25  
**Autor:** Eduardo  
**Status:** Aprovado

---

## Contexto

O projeto Modo Mercado foi originalmente especificado em Swift/SwiftUI + SwiftData para iOS nativo. A adaptação migra para **Flutter + Dart** para permitir:

- Desenvolvimento e testes 100% em Linux
- Geração do `.ipa` instalável via GitHub Actions (runner macOS)
- Instalação no iPhone via sideload (AltStore / Sideloadly), sem App Store

Os requisitos funcionais e as 13 propriedades de corretude do spec original são preservados integralmente.

---

## Stack Técnica

| Camada | Tecnologia | Justificativa |
|---|---|---|
| UI | Flutter 3.x + Dart | Cross-platform, testável no Linux |
| Estado | Riverpod 2.x | Injeção de dependência + reatividade |
| Persistência | Drift (SQLite) | Type-safe, testável in-memory no Linux |
| Gráficos | fl_chart | Gráfico de linha para histórico de preços |
| Testes | flutter_test + faker | Unit, widget e property-based tests |
| CI/CD | GitHub Actions | Pipeline test (Linux) + build (macOS) |

---

## Arquitetura

Clean Architecture + Feature-First. Três camadas por feature:

```
lib/
├── main.dart                          # Entry point, ProviderScope
├── app/
│   ├── app.dart                       # MaterialApp + roteamento
│   └── router.dart                    # GoRouter com rotas tipadas
│
├── core/
│   ├── domain/
│   │   ├── models/                    # Entidades de domínio (classes imutáveis)
│   │   │   ├── produto.dart
│   │   │   ├── registro_de_preco.dart
│   │   │   ├── mercado.dart
│   │   │   ├── lista_de_compras.dart
│   │   │   └── item_de_lista.dart
│   │   └── errors/
│   │       └── app_error.dart         # Hierarquia de erros
│   ├── protocols/                     # Interfaces de repositório (abstract classes)
│   │   ├── produto_repository.dart
│   │   ├── registro_repository.dart
│   │   ├── mercado_repository.dart
│   │   └── lista_repository.dart
│   └── formatters/
│       └── money_formatter.dart       # Conversão int (centavos) ↔ Decimal
│
├── features/
│   ├── produtos/
│   │   ├── domain/use_cases/
│   │   ├── data/
│   │   └── presentation/
│   ├── registros/
│   ├── historico/
│   ├── lista_de_compras/
│   ├── dashboard/
│   └── comparacao/
│
└── infrastructure/
    ├── database/
    │   ├── app_database.dart          # Drift AppDatabase
    │   ├── tables/                    # Definições de tabelas Drift
    │   └── daos/                      # DAOs por feature
    └── repositories/                  # Implementações concretas
```

---

## Modelos de Domínio

Classes imutáveis com `==` e `hashCode` via `equatable` ou `freezed`:

```dart
class Produto {
  final String id;        // UUID
  final String nome;
  final String categoria;
  final String unidade;
  final String? marca;
  final double? quantidade;
  final String? observacao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
}

class RegistroDePreco {
  final String id;
  final String produtoId;
  final String mercadoId;
  final int valorCentavos;   // Decimal armazenado como centavos (int)
  final DateTime data;
  final String? fotoPath;
  final DateTime criadoEm;
}

class Mercado {
  final String id;
  final String nome;
  final DateTime criadoEm;
}

class ListaDeCompras {
  final String id;
  final String nome;
  final List<ItemDeLista> itens;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  int get totalEstimadoCentavos =>
      itens.fold(0, (acc, item) => acc + item.subtotalEstimadoCentavos);
}

class ItemDeLista {
  final String id;
  final String produtoId;
  final double quantidade;
  final bool concluido;
  final int? ultimoPrecoRegistradoCentavos;

  int get subtotalEstimadoCentavos {
    final preco = ultimoPrecoRegistradoCentavos;
    if (preco == null) return 0;
    return (preco * quantidade).round();
  }
}
```

---

## Persistência (Drift)

Tabelas SQLite geradas via Drift com relacionamentos:

- `produtos` → `registros_de_preco` (cascade delete)
- `listas_de_compras` → `itens_de_lista` (cascade delete)
- `mercados` → `registros_de_preco` (set null on delete)

Valores monetários armazenados como `INTEGER` (centavos) — evita imprecisão de ponto flutuante.

DAOs injetados via Riverpod nos repositórios concretos.

---

## Hierarquia de Erros

```dart
sealed class AppError implements Exception {
  // Validação
  const factory AppError.campoObrigatorioAusente(String campo) = _CampoObrigatorio;
  const factory AppError.valorInvalido(String campo, String motivo) = _ValorInvalido;
  const factory AppError.produtoSemPreco(String nomeProduto) = _ProdutoSemPreco;

  // Persistência
  const factory AppError.falhaAoSalvar(String entidade, Object causa) = _FalhaAoSalvar;
  const factory AppError.falhaAoLer(String entidade, Object causa) = _FalhaAoLer;
  const factory AppError.falhaAoExcluir(String entidade, Object causa) = _FalhaAoExcluir;

  // Negócio
  const factory AppError.produtoPossuiRegistros(String nomeProduto) = _ProdutoPossuiRegistros;
}
```

---

## Testes

### Estratégia

| Tipo | Ferramenta | Onde roda |
|---|---|---|
| Unit (use cases, DAOs) | flutter_test | Linux |
| Widget (views isoladas) | flutter_test | Linux |
| Property-based (13 propriedades) | flutter_test + faker | Linux |
| UI end-to-end | flutter_test integration | Linux (headless) |

### Property-Based Tests

As 13 propriedades do spec original são implementadas com geração manual de dados aleatórios usando `faker` e `dart:math`. Cada teste gera 100+ instâncias e verifica o invariante.

Exemplo:
```dart
test('Property 4: histórico sempre ordenado do mais recente ao mais antigo', () {
  for (var i = 0; i < 100; i++) {
    final registros = gerarRegistrosAleatorios();
    final resultado = calcularMetricasUseCase.executar(registros);
    expect(estaOrdenadoDecrescente(resultado.registros), isTrue);
  }
});
```

---

## GitHub Actions Pipeline

### Job 1: `test` (ubuntu-latest)

```yaml
- flutter pub get
- flutter analyze
- flutter test --coverage
```

### Job 2: `build-ios` (macos-latest, depende de `test`)

```yaml
- flutter pub get
- flutter build ipa --no-codesign
- upload-artifact: build/ios/ipa/*.ipa
```

O `.ipa` gerado sem assinatura é baixado dos artifacts do GitHub e re-assinado localmente com AltStore ou Sideloadly antes de instalar no iPhone.

---

## Navegação (GoRouter)

```
/                     → DashboardView
/produtos             → ProdutosListView
/produtos/novo        → ProdutoFormView
/produtos/:id/editar  → ProdutoFormView
/produtos/:id/historico → HistoricoView
/produtos/:id/comparacao → ComparacaoView
/registros/novo       → RegistroFormView
/listas               → ListasView
/listas/:id           → ListaDetalheView
```

---

## Decisões Técnicas

**Por que `int` (centavos) em vez de `double` para dinheiro?**
`double` tem imprecisão de ponto flutuante. `0.1 + 0.2 != 0.3` em Dart. Armazenar como centavos inteiros elimina esse problema completamente.

**Por que Riverpod em vez de Provider ou Bloc?**
Riverpod tem injeção de dependência nativa (sem `BuildContext`), o que facilita testes de use cases e repositórios sem precisar de widget tree.

**Por que `--no-codesign` no build?**
Assinatura de código iOS requer certificados Apple armazenados como secrets no GitHub. Para uso pessoal com sideload, é mais simples assinar localmente com AltStore/Sideloadly após baixar o artifact.
