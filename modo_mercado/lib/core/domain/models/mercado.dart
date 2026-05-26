import 'package:equatable/equatable.dart';

class Mercado extends Equatable {
  final String id;
  final String nome;
  final DateTime criadoEm;

  const Mercado({
    required this.id,
    required this.nome,
    required this.criadoEm,
  });

  Mercado copyWith({String? id, String? nome, DateTime? criadoEm}) {
    return Mercado(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  List<Object?> get props => [id, nome, criadoEm];
}
