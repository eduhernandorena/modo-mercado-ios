import '../../../../core/domain/models/dashboard_data.dart';
import '../../../../core/protocols/produto_repository.dart';
import '../../../../core/protocols/registro_repository.dart';

class CalcularDashboardUseCase {
  final RegistroRepository registroRepository;
  final ProdutoRepository produtoRepository;
  const CalcularDashboardUseCase(this.registroRepository, this.produtoRepository);

  Future<DashboardData> executar(DateTime mes) async {
    final inicioMes = DateTime(mes.year, mes.month, 1);
    final fimMes = DateTime(mes.year, mes.month + 1, 0, 23, 59, 59);
    final inicioMesAnterior = DateTime(mes.year, mes.month - 1, 1);
    final fimMesAnterior = DateTime(mes.year, mes.month, 0, 23, 59, 59);

    final registrosMes = await registroRepository.listarPorPeriodo(inicioMes, fimMes);
    final registrosMesAnterior =
        await registroRepository.listarPorPeriodo(inicioMesAnterior, fimMesAnterior);

    if (registrosMes.isEmpty) {
      return const DashboardData(
        totalMesCentavos: 0,
        topCategorias: [],
        produtosComMaiorAumento: [],
        economiaEstimadaCentavos: 0,
        temDados: false,
      );
    }

    final produtos = await produtoRepository.listar();
    final produtoMap = {for (final p in produtos) p.id: p};

    // Total do mês
    final totalMes = registrosMes.fold(0, (acc, r) => acc + r.valorCentavos);

    // Top 3 categorias por soma de gastos
    final gastosPorCategoria = <String, int>{};
    for (final r in registrosMes) {
      final produto = produtoMap[r.produtoId];
      if (produto == null) continue;
      gastosPorCategoria[produto.categoria] =
          (gastosPorCategoria[produto.categoria] ?? 0) + r.valorCentavos;
    }
    final topCategorias = gastosPorCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3Categorias = topCategorias
        .take(3)
        .map((e) => CategoriaGasto(categoria: e.key, totalGastoCentavos: e.value))
        .toList();

    // Top 3 produtos com maior aumento percentual
    final precoMesPorProduto = <String, int>{};
    for (final r in registrosMes) {
      final atual = precoMesPorProduto[r.produtoId];
      if (atual == null || r.valorCentavos > atual) {
        precoMesPorProduto[r.produtoId] = r.valorCentavos;
      }
    }
    final precoMesAnteriorPorProduto = <String, int>{};
    for (final r in registrosMesAnterior) {
      final atual = precoMesAnteriorPorProduto[r.produtoId];
      if (atual == null || r.valorCentavos > atual) {
        precoMesAnteriorPorProduto[r.produtoId] = r.valorCentavos;
      }
    }

    final aumentos = <ProdutoAumento>[];
    for (final entry in precoMesPorProduto.entries) {
      final precoAnterior = precoMesAnteriorPorProduto[entry.key];
      if (precoAnterior == null || precoAnterior == 0) continue;
      final percentual = ((entry.value - precoAnterior) / precoAnterior) * 100;
      if (percentual > 0) {
        final produto = produtoMap[entry.key];
        if (produto != null) {
          aumentos.add(ProdutoAumento(produto: produto, percentualAumento: percentual));
        }
      }
    }
    aumentos.sort((a, b) => b.percentualAumento.compareTo(a.percentualAumento));
    final top3Aumentos = aumentos.take(3).toList();

    // Economia estimada: diferença entre maior preço e preço pago por produto no mês
    var economiaTotal = 0;
    for (final entry in precoMesPorProduto.entries) {
      final registrosDoProduto =
          registrosMes.where((r) => r.produtoId == entry.key).toList();
      if (registrosDoProduto.isEmpty) continue;
      final maiorPreco = registrosDoProduto
          .map((r) => r.valorCentavos)
          .reduce((a, b) => a > b ? a : b);
      final menorPago = registrosDoProduto
          .map((r) => r.valorCentavos)
          .reduce((a, b) => a < b ? a : b);
      final economia = maiorPreco - menorPago;
      if (economia > 0) economiaTotal += economia;
    }

    return DashboardData(
      totalMesCentavos: totalMes,
      topCategorias: top3Categorias,
      produtosComMaiorAumento: top3Aumentos,
      economiaEstimadaCentavos: economiaTotal,
      temDados: true,
    );
  }
}
