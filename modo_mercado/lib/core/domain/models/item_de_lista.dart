import 'package:equatable/equatable.dart';

class ItemDeLista extends Equatable {
  final String id;
  final String produtoId;
  final double quantidade;
  final bool concluido;
  final int? ultimoPrecoRegistradoCentavos;

  const ItemDeLista({
    required this.id,
    required this.produtoId,
    required this.quantidade,
    required this.concluido,
    this.ultimoPrecoRegistradoCentavos,
  });

  int get subtotalEstimadoCentavos {
    final preco = ultimoPrecoRegistradoCentavos;
    if (preco == null) return 0;
    return (preco * quantidade).round();
  }

  ItemDeLista copyWith({
    String? id,
    String? produtoId,
    double? quantidade,
    bool? concluido,
    int? ultimoPrecoRegistradoCentavos,
  }) {
    return ItemDeLista(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      quantidade: quantidade ?? this.quantidade,
      concluido: concluido ?? this.concluido,
      ultimoPrecoRegistradoCentavos:
          ultimoPrecoRegistradoCentavos ?? this.ultimoPrecoRegistradoCentavos,
    );
  }

  @override
  List<Object?> get props => [
        id, produtoId, quantidade, concluido,
        ultimoPrecoRegistradoCentavos,
      ];
}
