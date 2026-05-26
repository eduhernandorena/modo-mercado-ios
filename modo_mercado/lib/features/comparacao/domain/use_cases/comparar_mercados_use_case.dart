import '../../../../core/domain/models/comparacao_mercado.dart';
import '../../../../core/domain/models/mercado.dart';
import '../../../../core/protocols/mercado_repository.dart';
import '../../../../core/protocols/registro_repository.dart';

class CompararMercadosUseCase {
  final RegistroRepository registroRepository;
  final MercadoRepository mercadoRepository;
  const CompararMercadosUseCase(this.registroRepository, this.mercadoRepository);

  Future<List<ComparacaoMercado>> executar(String produtoId) async {
    final registros = await registroRepository.listarPorProduto(produtoId);
    if (registros.isEmpty) return [];

    // Agrupar por mercado e pegar o mais recente de cada
    final mercadoIds = registros.map((r) => r.mercadoId).toSet();
    final comparacoes = <ComparacaoMercado>[];

    for (final mercadoId in mercadoIds) {
      final ultimoRegistro = await registroRepository.ultimoPreco(produtoId, mercadoId);
      if (ultimoRegistro == null) continue;

      final mercado = await _buscarMercado(mercadoId);
      if (mercado == null) continue;

      comparacoes.add(ComparacaoMercado(
        mercado: mercado,
        ultimoPrecoCentavos: ultimoRegistro.valorCentavos,
        dataUltimoRegistro: ultimoRegistro.data,
        eMenorPreco: false, // será definido após ordenação
      ));
    }

    // Ordenar do menor para o maior preço
    comparacoes.sort((a, b) => a.ultimoPrecoCentavos.compareTo(b.ultimoPrecoCentavos));

    // Marcar apenas o primeiro como menor preço
    if (comparacoes.isNotEmpty) {
      comparacoes[0] = ComparacaoMercado(
        mercado: comparacoes[0].mercado,
        ultimoPrecoCentavos: comparacoes[0].ultimoPrecoCentavos,
        dataUltimoRegistro: comparacoes[0].dataUltimoRegistro,
        eMenorPreco: true,
      );
    }

    return comparacoes;
  }

  Future<Mercado?> _buscarMercado(String mercadoId) async {
    final mercados = await mercadoRepository.listar();
    try {
      return mercados.firstWhere((m) => m.id == mercadoId);
    } catch (_) {
      return null;
    }
  }
}
