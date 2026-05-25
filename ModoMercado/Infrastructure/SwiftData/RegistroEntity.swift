import Foundation
import SwiftData

@Model
final class RegistroEntity {
    @Attribute(.unique) var id: UUID
    var produtoId: UUID
    var mercadoId: UUID
    var valor: Double          // SwiftData não suporta Decimal nativamente; converte via EntityFormatter
    var data: Date
    var fotoPath: String?
    var criadoEm: Date

    var produto: ProdutoEntity?
    var mercado: MercadoEntity?

    init(
        id: UUID = UUID(),
        produtoId: UUID,
        mercadoId: UUID,
        valor: Double,
        data: Date = Date(),
        fotoPath: String? = nil,
        criadoEm: Date = Date()
    ) {
        self.id = id
        self.produtoId = produtoId
        self.mercadoId = mercadoId
        self.valor = valor
        self.data = data
        self.fotoPath = fotoPath
        self.criadoEm = criadoEm
    }
}
