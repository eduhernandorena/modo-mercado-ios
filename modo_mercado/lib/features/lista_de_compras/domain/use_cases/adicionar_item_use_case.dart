import 'package:uuid/uuid.dart';
import '../../../../core/domain/errors/app_error.dart';
import '../../../../core/domain/models/item_de_lista.dart';
import '../../../../core/domain/models/lista_de_compras.dart';
import '../../../../core/domain/models/produto.dart';
import '../../../../core/protocols/lista_repository.dart';
import '../../../../core/protocols/registro_repository.dart';

class AdicionarItemUseCase {
  final ListaRepository listaRepository;
  final RegistroRepository registroRepository;
  const AdicionarItemUseCase(this.listaRepository, this.registroRepository);

  Future<ListaDeCompras> executar({
    required ListaDeCompras lista,
    required Produto produto,
    required double quantidade,
  }) async {
    // Verificar se produto tem ao menos um registro de preço
    final registros = await registroRepository.listarPorProduto(produto.id);
    if (registros.isEmpty) {
      throw AppError.produtoSemPreco(produto.nome);
    }

    // Capturar último preço no momento da adição
    registros.sort((a, b) => b.data.compareTo(a.data));
    final ultimoPreco = registros.first.valorCentavos;

    final item = ItemDeLista(
      id: const Uuid().v4(),
      produtoId: produto.id,
      quantidade: quantidade,
      concluido: false,
      ultimoPrecoRegistradoCentavos: ultimoPreco,
    );

    final listaAtualizada = lista.copyWith(
      itens: [...lista.itens, item],
      atualizadoEm: DateTime.now(),
    );
    await listaRepository.atualizar(listaAtualizada);
    return listaAtualizada;
  }
}
