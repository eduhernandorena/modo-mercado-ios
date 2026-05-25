import Foundation
import SwiftData

@Model
final class ItemEntity {
    @Attribute(.unique) var id: UUID
    var produtoId: UUID
    var quantidade: Double
    var concluido: Bool
    var ultimoPrecoRegistrado: Double?   // Decimal convertido via EntityFormatter

    var lista: ListaEntity?

    init(
        id: UUID = UUID(),
        produtoId: UUID,
        quantidade: Double,
        concluido: Bool = false,
        ultimoPrecoRegistrado: Double? = nil
    ) {
        self.id = id
        self.produtoId = produtoId
        self.quantidade = quantidade
        self.concluido = concluido
        self.ultimoPrecoRegistrado = ultimoPrecoRegistrado
    }
}
