import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/dashboard_data.dart';
import '../../../infrastructure/providers.dart';

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  final Ref _ref;

  DashboardNotifier(this._ref) : super(const AsyncValue.loading()) {
    carregar();
  }

  Future<void> carregar() async {
    state = const AsyncValue.loading();
    try {
      final useCase = _ref.read(calcularDashboardUseCaseProvider);
      final data = await useCase.executar(DateTime.now());
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>(
        (ref) => DashboardNotifier(ref));
