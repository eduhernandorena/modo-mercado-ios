import Foundation

struct RegistroDePreco: Identifiable, Equatable, Codable {
    let id: UUID
    let produtoId: UUID
    let mercadoId: UUID
    var valor: Decimal        // Decimal para precisão monetária
    var data: Date
    var fotoPath: String?     // Caminho local da imagem
    let criadoEm: Date

    init(
        id: UUID = UUID(),
        produtoId: UUID,
        mercadoId: UUID,
        valor: Decimal,
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
