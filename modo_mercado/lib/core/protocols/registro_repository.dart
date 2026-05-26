import '../domain/models/registro_de_preco.dart';

abstract class RegistroRepository {
  Future<List<RegistroDePreco>> listarPorProduto(String produtoId);
  Future<List<RegistroDePreco>> listarPorMercado(String mercadoId);
  Future<List<RegistroDePreco>> listarPorPeriodo(DateTime inicio, DateTime fim);
  Future<void> salvar(RegistroDePreco registro);
  Future<void> excluir(String id);
  Future<RegistroDePreco?> ultimoPreco(String produtoId, String mercadoId);
}
