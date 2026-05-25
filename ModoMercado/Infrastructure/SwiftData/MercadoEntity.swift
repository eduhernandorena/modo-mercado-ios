import Foundation
import SwiftData

@Model
final class MercadoEntity {
    @Attribute(.unique) var id: UUID
    var nome: String
    var criadoEm: Date

    @Relationship(deleteRule: .nullify)
    var registros: [RegistroEntity] = []

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
