import 'registro_de_preco.dart';

class MetricasHistorico {
  final int? menorPrecoCentavos;
  final int? maiorPrecoCentavos;
  final int? mediaPrecoCentavos;
  final List<RegistroDePreco> registros;

  const MetricasHistorico({
    this.menorPrecoCentavos,
    this.maiorPrecoCentavos,
    this.mediaPrecoCentavos,
    required this.registros,
  });
}
