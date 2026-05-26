import 'package:equatable/equatable.dart';

class RegistroDePreco extends Equatable {
  final String id;
  final String produtoId;
  final String mercadoId;
  final int valorCentavos;
  final DateTime data;
  final String? fotoPath;
  final DateTime criadoEm;

  const RegistroDePreco({
    required this.id,
    required this.produtoId,
    required this.mercadoId,
    required this.valorCentavos,
    required this.data,
    this.fotoPath,
    required this.criadoEm,
  });

  RegistroDePreco copyWith({
    String? id,
    String? produtoId,
    String? mercadoId,
    int? valorCentavos,
    DateTime? data,
    String? fotoPath,
    DateTime? criadoEm,
  }) {
    return RegistroDePreco(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      mercadoId: mercadoId ?? this.mercadoId,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      data: data ?? this.data,
      fotoPath: fotoPath ?? this.fotoPath,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  List<Object?> get props => [
        id, produtoId, mercadoId, valorCentavos,
        data, fotoPath, criadoEm,
      ];
}
