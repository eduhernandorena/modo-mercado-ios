import 'produto.dart';

class CategoriaGasto {
  final String categoria;
  final int totalGastoCentavos;
  const CategoriaGasto({required this.categoria, required this.totalGastoCentavos});
}

class ProdutoAumento {
  final Produto produto;
  final double percentualAumento;
  const ProdutoAumento({required this.produto, required this.percentualAumento});
}

class DashboardData {
  final int totalMesCentavos;
  final List<CategoriaGasto> topCategorias;
  final List<ProdutoAumento> produtosComMaiorAumento;
  final int economiaEstimadaCentavos;
  final bool temDados;

  const DashboardData({
    required this.totalMesCentavos,
    required this.topCategorias,
    required this.produtosComMaiorAumento,
    required this.economiaEstimadaCentavos,
    required this.temDados,
  });
}
