import Foundation

struct ListaDeCompras: Identifiable, Equatable, Codable {
    let id: UUID
    var nome: String
    var itens: [ItemDeLista]
    let criadoEm: Date
    var atualizadoEm: Date

    var totalEstimado: Decimal {
        itens.reduce(Decimal.zero) { $0 + $1.subtotalEstimado }
    }

    init(
        id: UUID = UUID(),
        nome: String,
        itens: [ItemDeLista] = [],
        criadoEm: Date = Date(),
        atualizadoEm: Date = Date()
    ) {
        self.id = id
        self.nome = nome
        self.itens = itens
        self.criadoEm = criadoEm
        self.atualizadoEm = atualizadoEm
    }
}
