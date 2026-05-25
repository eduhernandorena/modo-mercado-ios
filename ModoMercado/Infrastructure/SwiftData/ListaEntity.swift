import Foundation
import SwiftData

@Model
final class ListaEntity {
    @Attribute(.unique) var id: UUID
    var nome: String
    var criadoEm: Date
    var atualizadoEm: Date

    @Relationship(deleteRule: .cascade)
    var itens: [ItemEntity] = []

    init(
        id: UUID = UUID(),
        nome: String,
        criadoEm: Date = Date(),
        atualizadoEm: Date = Date()
    ) {
        self.id = id
        self.nome = nome
        self.criadoEm = criadoEm
        self.atualizadoEm = atualizadoEm
    }
}
