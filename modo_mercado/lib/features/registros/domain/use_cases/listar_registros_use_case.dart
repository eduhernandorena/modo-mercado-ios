import '../../../../core/domain/models/registro_de_preco.dart';
import '../../../../core/protocols/registro_repository.dart';

class ListarRegistrosUseCase {
  final RegistroRepository repository;
  const ListarRegistrosUseCase(this.repository);

  Future<List<RegistroDePreco>> executar(String produtoId) async {
    final registros = await repository.listarPorProduto(produtoId);
    // Ordenar do mais recente ao mais antigo
    final ordenados = List<RegistroDePreco>.from(registros)
      ..sort((a, b) => b.data.compareTo(a.data));
    return ordenados;
  }
}
