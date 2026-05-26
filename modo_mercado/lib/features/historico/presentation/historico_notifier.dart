import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/metricas_historico.dart';
import '../../../core/domain/models/mercado.dart';
import '../../../infrastructure/providers.dart';

class HistoricoState {
  final MetricasHistorico? metricas;
  final List<Mercado> mercados;
  final String? filtroMercadoId;
  final DateTime? periodoInicio;
  final DateTime? periodoFim;
  final bool isLoading;
  final String? errorMessage;

  const HistoricoState({
    this.metricas,
    this.mercados = const [],
    this.filtroMercadoId,
    this.periodoInicio,
    this.periodoFim,
    this.isLoading = false,
    this.errorMessage,
  });

  HistoricoState copyWith({
    MetricasHistorico? metricas,
    List<Mercado>? mercados,
    String? filtroMercadoId,
    DateTime? periodoInicio,
    DateTime? periodoFim,
    bool? isLoading,
    String? errorMessage,
    bool clearFiltroMercado = false,
    bool clearPeriodo = false,
    bool clearError = false,
  }) {
    return HistoricoState(
      metricas: metricas ?? this.metricas,
      mercados: mercados ?? this.mercados,
      filtroMercadoId: clearFiltroMercado ? null : (filtroMercadoId ?? this.filtroMercadoId),
      periodoInicio: clearPeriodo ? null : (periodoInicio ?? this.periodoInicio),
      periodoFim: clearPeriodo ? null : (periodoFim ?? this.periodoFim),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class HistoricoNotifier extends StateNotifier<HistoricoState> {
  final Ref _ref;
  final String produtoId;

  HistoricoNotifier(this._ref, this.produtoId) : super(const HistoricoState()) {
    carregar();
  }

  Future<void> carregar() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final useCase = _ref.read(calcularMetricasUseCaseProvider);
      final metricas = await useCase.executar(
        produtoId: produtoId,
        filtroMercadoId: state.filtroMercadoId,
        periodoInicio: state.periodoInicio,
        periodoFim: state.periodoFim,
      );
      final repo = _ref.read(mercadoRepositoryProvider);
      final mercados = await repo.listar();
      state = state.copyWith(metricas: metricas, mercados: mercados, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  void filtrarPorMercado(String? mercadoId) {
    state = state.copyWith(
      filtroMercadoId: mercadoId,
      clearFiltroMercado: mercadoId == null,
    );
    carregar();
  }

  void filtrarPorPeriodo(DateTime? inicio, DateTime? fim) {
    state = state.copyWith(
      periodoInicio: inicio,
      periodoFim: fim,
      clearPeriodo: inicio == null && fim == null,
    );
    carregar();
  }
}

final historicoNotifierProvider = StateNotifierProvider.family<
    HistoricoNotifier, HistoricoState, String>(
  (ref, produtoId) => HistoricoNotifier(ref, produtoId),
);
