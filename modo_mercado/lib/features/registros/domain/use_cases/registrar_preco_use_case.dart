import 'package:uuid/uuid.dart';
import '../../../../core/domain/errors/app_error.dart';
import '../../../../core/domain/models/registro_de_preco.dart';
import '../../../../core/protocols/registro_repository.dart';

class RegistrarPrecoUseCase {
  final RegistroRepository repository;
  const RegistrarPrecoUseCase(this.repository);

  Future<RegistroDePreco> executar({
    required String produtoId,
    required String mercadoId,
    required int valorCentavos,
    required DateTime data,
    String? fotoPath,
  }) async {
    if (produtoId.trim().isEmpty) throw const AppError.campoObrigatorioAusente('produto');
    if (mercadoId.trim().isEmpty) throw const AppError.campoObrigatorioAusente('mercado');
    if (valorCentavos <= 0) {
      throw const AppError.valorInvalido('valor', 'deve ser maior que zero');
    }

    final registro = RegistroDePreco(
      id: const Uuid().v4(),
      produtoId: produtoId,
      mercadoId: mercadoId,
      valorCentavos: valorCentavos,
      data: data,
      fotoPath: fotoPath,
      criadoEm: DateTime.now(),
    );
    await repository.salvar(registro);
    return registro;
  }
}
