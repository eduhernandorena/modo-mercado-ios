import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/comparacao_mercado.dart';
import '../../../infrastructure/providers.dart';

class ComparacaoState {
  final List<ComparacaoMercado> comparacoes;
  final bool isLoading;
  final String? errorMessage;

  const ComparacaoState({
    this.comparacoes = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}

class ComparacaoNotifier extends StateNotifier<ComparacaoState> {
  final Ref _ref;
  final String produtoId;

  ComparacaoNotifier(this._ref, this.produtoId) : super(const ComparacaoState()) {
    carregar();
  }

  Future<void> carregar() async {
    state = const ComparacaoState(isLoading: true);
    try {
      final useCase = _ref.read(compararMercadosUseCaseProvider);
      final comparacoes = await useCase.executar(produtoId);
      state = ComparacaoState(comparacoes: comparacoes);
    } catch (e) {
      state = ComparacaoState(errorMessage: e.toString());
    }
  }
}

final comparacaoNotifierProvider = StateNotifierProvider.family<
    ComparacaoNotifier, ComparacaoState, String>(
  (ref, produtoId) => ComparacaoNotifier(ref, produtoId),
);
