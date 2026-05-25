import Foundation

struct ItemDeLista: Identifiable, Equatable, Codable {
    let id: UUID
    let produtoId: UUID
    var quantidade: Double
    var concluido: Bool
    var ultimoPrecoRegistrado: Decimal?   // snapshot no momento da adição

    var subtotalEstimado: Decimal {
        guard let preco = ultimoPrecoRegistrado else { return .zero }
        return preco * Decimal(quantidade)
    }

    init(
        id: UUID = UUID(),
        produtoId: UUID,
        quantidade: Double,
        concluido: Bool = false,
        ultimoPrecoRegistrado: Decimal? = nil
    ) {
        self.id = id
        self.produtoId = produtoId
        self.quantidade = quantidade
        self.concluido = concluido
        self.ultimoPrecoRegistrado = ultimoPrecoRegistrado
    }
}
