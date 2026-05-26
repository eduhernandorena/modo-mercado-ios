import 'mercado.dart';

class ComparacaoMercado {
  final Mercado mercado;
  final int ultimoPrecoCentavos;
  final DateTime dataUltimoRegistro;
  final bool eMenorPreco;

  const ComparacaoMercado({
    required this.mercado,
    required this.ultimoPrecoCentavos,
    required this.dataUltimoRegistro,
    required this.eMenorPreco,
  });
}
