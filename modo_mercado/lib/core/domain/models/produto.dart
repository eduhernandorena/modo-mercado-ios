import 'package:equatable/equatable.dart';

class Produto extends Equatable {
  final String id;
  final String nome;
  final String categoria;
  final String unidade;
  final String? marca;
  final double? quantidade;
  final String? observacao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  const Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.unidade,
    this.marca,
    this.quantidade,
    this.observacao,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  Produto copyWith({
    String? id,
    String? nome,
    String? categoria,
    String? unidade,
    String? marca,
    double? quantidade,
    String? observacao,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Produto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      unidade: unidade ?? this.unidade,
      marca: marca ?? this.marca,
      quantidade: quantidade ?? this.quantidade,
      observacao: observacao ?? this.observacao,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  List<Object?> get props => [
        id, nome, categoria, unidade, marca,
        quantidade, observacao, criadoEm, atualizadoEm,
      ];
}
