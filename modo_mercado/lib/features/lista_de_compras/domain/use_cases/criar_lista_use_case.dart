import 'package:uuid/uuid.dart';
import '../../../../core/domain/errors/app_error.dart';
import '../../../../core/domain/models/lista_de_compras.dart';
import '../../../../core/protocols/lista_repository.dart';

class CriarListaUseCase {
  final ListaRepository repository;
  const CriarListaUseCase(this.repository);

  Future<ListaDeCompras> executar(String nome) async {
    if (nome.trim().isEmpty) throw const AppError.campoObrigatorioAusente('nome');

    final agora = DateTime.now();
    final lista = ListaDeCompras(
      id: const Uuid().v4(),
      nome: nome.trim(),
      itens: const [],
      criadoEm: agora,
      atualizadoEm: agora,
    );
    await repository.salvar(lista);
    return lista;
  }
}
