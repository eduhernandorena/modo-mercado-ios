import '../domain/models/lista_de_compras.dart';

abstract class ListaRepository {
  Future<List<ListaDeCompras>> listar();
  Future<void> salvar(ListaDeCompras lista);
  Future<void> atualizar(ListaDeCompras lista);
  Future<void> excluir(String id);
}
