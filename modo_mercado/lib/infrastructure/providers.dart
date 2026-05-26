// Providers Riverpod para injeção de dependência.
// Instancia repositórios concretos e use cases.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/database/app_database.dart';
import '../infrastructure/database/daos/produto_dao.dart';
import '../infrastructure/database/daos/mercado_dao.dart';
import '../infrastructure/database/daos/registro_dao.dart';
import '../infrastructure/database/daos/lista_dao.dart';
import '../infrastructure/repositories/drift_produto_repository.dart';
import '../infrastructure/repositories/drift_mercado_repository.dart';
import '../infrastructure/repositories/drift_registro_repository.dart';
import '../infrastructure/repositories/drift_lista_repository.dart';
import '../core/protocols/produto_repository.dart';
import '../core/protocols/mercado_repository.dart';
import '../core/protocols/registro_repository.dart';
import '../core/protocols/lista_repository.dart';
import '../features/produtos/domain/use_cases/cadastrar_produto_use_case.dart';
import '../features/produtos/domain/use_cases/editar_produto_use_case.dart';
import '../features/produtos/domain/use_cases/excluir_produto_use_case.dart';
import '../features/produtos/domain/use_cases/listar_produtos_use_case.dart';
import '../features/registros/domain/use_cases/registrar_preco_use_case.dart';
import '../features/registros/domain/use_cases/listar_registros_use_case.dart';
import '../features/historico/domain/use_cases/calcular_metricas_use_case.dart';
import '../features/lista_de_compras/domain/use_cases/criar_lista_use_case.dart';
import '../features/lista_de_compras/domain/use_cases/adicionar_item_use_case.dart';
import '../features/lista_de_compras/domain/use_cases/calcular_total_use_case.dart';
import '../features/comparacao/domain/use_cases/comparar_mercados_use_case.dart';
import '../features/dashboard/domain/use_cases/calcular_dashboard_use_case.dart';

// --- Database ---
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// --- DAOs ---
final produtoDaoProvider = Provider<ProdutoDao>(
    (ref) => ProdutoDao(ref.watch(appDatabaseProvider)));
final mercadoDaoProvider = Provider<MercadoDao>(
    (ref) => MercadoDao(ref.watch(appDatabaseProvider)));
final registroDaoProvider = Provider<RegistroDao>(
    (ref) => RegistroDao(ref.watch(appDatabaseProvider)));
final listaDaoProvider = Provider<ListaDao>(
    (ref) => ListaDao(ref.watch(appDatabaseProvider)));

// --- Repositórios ---
final produtoRepositoryProvider = Provider<ProdutoRepository>(
    (ref) => DriftProdutoRepository(ref.watch(produtoDaoProvider)));
final mercadoRepositoryProvider = Provider<MercadoRepository>(
    (ref) => DriftMercadoRepository(ref.watch(mercadoDaoProvider)));
final registroRepositoryProvider = Provider<RegistroRepository>(
    (ref) => DriftRegistroRepository(ref.watch(registroDaoProvider)));
final listaRepositoryProvider = Provider<ListaRepository>(
    (ref) => DriftListaRepository(ref.watch(listaDaoProvider)));

// --- Use Cases ---
final cadastrarProdutoUseCaseProvider = Provider<CadastrarProdutoUseCase>(
    (ref) => CadastrarProdutoUseCase(ref.watch(produtoRepositoryProvider)));
final editarProdutoUseCaseProvider = Provider<EditarProdutoUseCase>(
    (ref) => EditarProdutoUseCase(ref.watch(produtoRepositoryProvider)));
final excluirProdutoUseCaseProvider = Provider<ExcluirProdutoUseCase>(
    (ref) => ExcluirProdutoUseCase(ref.watch(produtoRepositoryProvider)));
final listarProdutosUseCaseProvider = Provider<ListarProdutosUseCase>(
    (ref) => ListarProdutosUseCase(ref.watch(produtoRepositoryProvider)));

final registrarPrecoUseCaseProvider = Provider<RegistrarPrecoUseCase>(
    (ref) => RegistrarPrecoUseCase(ref.watch(registroRepositoryProvider)));
final listarRegistrosUseCaseProvider = Provider<ListarRegistrosUseCase>(
    (ref) => ListarRegistrosUseCase(ref.watch(registroRepositoryProvider)));

final calcularMetricasUseCaseProvider = Provider<CalcularMetricasUseCase>(
    (ref) => CalcularMetricasUseCase(ref.watch(registroRepositoryProvider)));

final criarListaUseCaseProvider = Provider<CriarListaUseCase>(
    (ref) => CriarListaUseCase(ref.watch(listaRepositoryProvider)));
final adicionarItemUseCaseProvider = Provider<AdicionarItemUseCase>((ref) =>
    AdicionarItemUseCase(ref.watch(listaRepositoryProvider),
        ref.watch(registroRepositoryProvider)));
final calcularTotalUseCaseProvider =
    Provider<CalcularTotalUseCase>((_) => const CalcularTotalUseCase());

final compararMercadosUseCaseProvider = Provider<CompararMercadosUseCase>(
    (ref) => CompararMercadosUseCase(ref.watch(registroRepositoryProvider),
        ref.watch(mercadoRepositoryProvider)));

final calcularDashboardUseCaseProvider = Provider<CalcularDashboardUseCase>(
    (ref) => CalcularDashboardUseCase(ref.watch(registroRepositoryProvider),
        ref.watch(produtoRepositoryProvider)));
