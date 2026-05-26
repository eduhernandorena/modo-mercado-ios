import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/lista_de_compras.dart';
import '../../../core/domain/models/produto.dart';
import '../../../infrastructure/providers.dart';

class ListaState {
  final List<ListaDeCompras> listas;
  final bool isLoading;
  final String? errorMessage;

  const ListaState({
    this.listas = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ListaState copyWith({
    List<ListaDeCompras>? listas,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ListaState(
      listas: listas ?? this.listas,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ListaNotifier extends StateNotifier<ListaState> {
  final Ref _ref;

  ListaNotifier(this._ref) : super(const ListaState()) {
    carregar();
  }

  Future<void> carregar() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = _ref.read(listaRepositoryProvider);
      final listas = await repo.listar();
      state = state.copyWith(listas: listas, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> criar(String nome) async {
    try {
      final useCase = _ref.read(criarListaUseCaseProvider);
      await useCase.executar(nome);
      await carregar();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> adicionarItem(ListaDeCompras lista, Produto produto, double quantidade) async {
    try {
      final useCase = _ref.read(adicionarItemUseCaseProvider);
      await useCase.executar(lista: lista, produto: produto, quantidade: quantidade);
      await carregar();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> marcarConcluido(ListaDeCompras lista, String itemId, bool concluido) async {
    try {
      final repo = _ref.read(listaRepositoryProvider);
      final itensAtualizados = lista.itens.map((item) {
        return item.id == itemId ? item.copyWith(concluido: concluido) : item;
      }).toList();
      await repo.atualizar(lista.copyWith(itens: itensAtualizados));
      await carregar();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> removerItem(ListaDeCompras lista, String itemId) async {
    try {
      final repo = _ref.read(listaRepositoryProvider);
      final itensAtualizados = lista.itens.where((i) => i.id != itemId).toList();
      await repo.atualizar(lista.copyWith(itens: itensAtualizados));
      await carregar();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<bool> excluir(String listaId) async {
    try {
      final repo = _ref.read(listaRepositoryProvider);
      await repo.excluir(listaId);
      await carregar();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  void limparErro() => state = state.copyWith(clearError: true);
}

final listaNotifierProvider =
    StateNotifierProvider<ListaNotifier, ListaState>(
        (ref) => ListaNotifier(ref));
