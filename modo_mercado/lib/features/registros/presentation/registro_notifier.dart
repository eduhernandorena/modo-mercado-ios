import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/mercado.dart';
import '../../../infrastructure/providers.dart';
import 'package:uuid/uuid.dart';class RegistroState {
  final List<Mercado> mercados;
  final String? errorMessage;
  final bool isLoading;
  final bool sucesso;

  const RegistroState({
    this.mercados = const [],
    this.errorMessage,
    this.isLoading = false,
    this.sucesso = false,
  });

  RegistroState copyWith({
    List<Mercado>? mercados,
    String? errorMessage,
    bool? isLoading,
    bool? sucesso,
    bool clearError = false,
  }) {
    return RegistroState(
      mercados: mercados ?? this.mercados,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
      sucesso: sucesso ?? this.sucesso,
    );
  }
}

class RegistroNotifier extends StateNotifier<RegistroState> {
  final Ref _ref;

  RegistroNotifier(this._ref) : super(const RegistroState()) {
    _carregarMercados();
  }

  Future<void> _carregarMercados() async {
    try {
      final repo = _ref.read(mercadoRepositoryProvider);
      final mercados = await repo.listar();
      state = state.copyWith(mercados: mercados);
    } catch (_) {}
  }

  Future<bool> registrar({
    required String produtoId,
    required String mercadoId,
    required int valorCentavos,
    required DateTime data,
    String? fotoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, sucesso: false);
    try {
      final useCase = _ref.read(registrarPrecoUseCaseProvider);
      await useCase.executar(
        produtoId: produtoId,
        mercadoId: mercadoId,
        valorCentavos: valorCentavos,
        data: data,
        fotoPath: fotoPath,
      );
      state = state.copyWith(isLoading: false, sucesso: true);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<String> criarMercado(String nome) async {
    final repo = _ref.read(mercadoRepositoryProvider);
    final mercado = Mercado(
      id: const Uuid().v4(),
      nome: nome.trim(),
      criadoEm: DateTime.now(),
    );
    await repo.salvar(mercado);
    await _carregarMercados();
    return mercado.id;
  }

  void limparErro() => state = state.copyWith(clearError: true);
}

final registroNotifierProvider =
    StateNotifierProvider<RegistroNotifier, RegistroState>(
        (ref) => RegistroNotifier(ref));
