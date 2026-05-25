import Foundation

struct Mercado: Identifiable, Equatable, Codable {
    let id: UUID
    var nome: String
    let criadoEm: Date

    init(
        id: UUID = UUID(),
        nome: String,
        criadoEm: Date = Date()
    ) {
        self.id = id
        self.nome = nome
        self.criadoEm = criadoEm
    }
}
