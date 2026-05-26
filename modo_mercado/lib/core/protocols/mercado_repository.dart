import '../domain/models/mercado.dart';

abstract class MercadoRepository {
  Future<List<Mercado>> listar();
  Future<void> salvar(Mercado mercado);
  Future<void> excluir(String id);
}
