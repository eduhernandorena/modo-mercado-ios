import Foundation
import SwiftData

@Model
final class ProdutoEntity {
    @Attribute(.unique) var id: UUID
    var nome: String
    var categoria: String
    var unidade: String
    var marca: String?
    var quantidade: Double?
    var observacao: String?
    var criadoEm: Date
    var atualizadoEm: Date

    @Relationship(deleteRule: .cascade)
    var registros: [RegistroEntity] = []

    init(
        id: UUID = UUID(),
        nome: String,
        categoria: String,
        unidade: String,
        marca: String? = nil,
        quantidade: Double? = nil,
        observacao: String? = nil,
        criadoEm: Date = Date(),
        atualizadoEm: Date = Date()
    ) {
        self.id = id
        self.nome = nome
        self.categoria = categoria
        self.unidade = unidade
        self.marca = marca
        self.quantidade = quantidade
        self.observacao = observacao
        self.criadoEm = criadoEm
        self.atualizadoEm = atualizadoEm
    }
}
