import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/produto.dart';
import '../../../infrastructure/providers.dart';

class ProdutosState {
  final List<Produto> produtos;
  final String termoBusca;
  final String? errorMessage;
  final bool isLoading;

  const ProdutosState({
    this.produtos = const [],
    this.termoBusca = '',
    this.errorMessage,
    this.isLoading = false,
  });

  ProdutosState copyWith({
    List<Produto>? produtos,
    String? termoBusca,
    String? errorMessage,
    bool? isLoading,
    bool clearError = false,
  }) {
    return ProdutosState(
      produtos: produtos ?? this.produtos,
      termoBusca: termoBusca ?? this.termoBusca,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProdutosNotifier extends StateNotifier<ProdutosState> {
  final Ref _ref;

  ProdutosNotifier(this._ref) : super(const ProdutosState()) {
    carregar();
  }

  Future<void> carregar({String? termoBusca}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final useCase = _ref.read(listarProdutosUseCaseProvider);
      final produtos = await useCase.executar(
          termoBusca: termoBusca ?? state.termoBusca);
      state = state.copyWith(
          produtos: produtos,
          termoBusca: termoBusca ?? state.termoBusca,
          isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> cadastrar({
    required String nome,
    required String categoria,
    required String unidade,
    String? marca,
    double? quantidade,
    String? observacao,
  }) async {
    try {
      final useCase = _ref.read(cadastrarProdutoUseCaseProvider);
      await useCase.executar(
          nome: nome,
          categoria: categoria,
          unidade: unidade,
          marca: marca,
          quantidade: quantidade,
          observacao: observacao);
      await carregar();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> editar(Produto produto) async {
    try {
      final useCase = _ref.read(editarProdutoUseCaseProvider);
      await useCase.executar(produto);
      await carregar();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> excluir(String produtoId, String nomeProduto) async {
    try {
      final useCase = _ref.read(excluirProdutoUseCaseProvider);
      await useCase.executar(produtoId, nomeProduto);
      await carregar();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  void limparErro() => state = state.copyWith(clearError: true);
}

final produtosNotifierProvider =
    StateNotifierProvider<ProdutosNotifier, ProdutosState>(
        (ref) => ProdutosNotifier(ref));
