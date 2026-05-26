import '../../../../core/domain/models/lista_de_compras.dart';

class CalcularTotalUseCase {
  const CalcularTotalUseCase();

  int executar(ListaDeCompras lista) {
    return lista.itens.fold(0, (acc, item) => acc + item.subtotalEstimadoCentavos);
  }
}
