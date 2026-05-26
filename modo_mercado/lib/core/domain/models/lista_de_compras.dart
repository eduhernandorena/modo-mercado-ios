import 'package:equatable/equatable.dart';
import 'item_de_lista.dart';

class ListaDeCompras extends Equatable {
  final String id;
  final String nome;
  final List<ItemDeLista> itens;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  const ListaDeCompras({
    required this.id,
    required this.nome,
    required this.itens,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  int get totalEstimadoCentavos =>
      itens.fold(0, (acc, item) => acc + item.subtotalEstimadoCentavos);

  ListaDeCompras copyWith({
    String? id,
    String? nome,
    List<ItemDeLista>? itens,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return ListaDeCompras(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      itens: itens ?? this.itens,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  List<Object?> get props => [id, nome, itens, criadoEm, atualizadoEm];
}
