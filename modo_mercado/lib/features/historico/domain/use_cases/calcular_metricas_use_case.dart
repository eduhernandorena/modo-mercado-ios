import '../../../../core/domain/models/metricas_historico.dart';
import '../../../../core/protocols/registro_repository.dart';

class CalcularMetricasUseCase {
  final RegistroRepository repository;
  const CalcularMetricasUseCase(this.repository);

  Future<MetricasHistorico> executar({
    required String produtoId,
    String? filtroMercadoId,
    DateTime? periodoInicio,
    DateTime? periodoFim,
  }) async {
    var registros = await repository.listarPorProduto(produtoId);

    // Aplicar filtro de mercado
    if (filtroMercadoId != null) {
      registros = registros.where((r) => r.mercadoId == filtroMercadoId).toList();
    }

    // Aplicar filtro de período
    if (periodoInicio != null) {
      registros = registros.where((r) => !r.data.isBefore(periodoInicio)).toList();
    }
    if (periodoFim != null) {
      registros = registros.where((r) => !r.data.isAfter(periodoFim)).toList();
    }

    // Ordenar do mais recente ao mais antigo
    registros.sort((a, b) => b.data.compareTo(a.data));

    if (registros.isEmpty) {
      return const MetricasHistorico(registros: []);
    }

    final valores = registros.map((r) => r.valorCentavos).toList();
    final menor = valores.reduce((a, b) => a < b ? a : b);
    final maior = valores.reduce((a, b) => a > b ? a : b);
    final media = (valores.reduce((a, b) => a + b) / valores.length).round();

    return MetricasHistorico(
      menorPrecoCentavos: menor,
      maiorPrecoCentavos: maior,
      mediaPrecoCentavos: media,
      registros: registros,
    );
  }
}
