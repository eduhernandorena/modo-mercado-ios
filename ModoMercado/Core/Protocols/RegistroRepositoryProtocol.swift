import Foundation

protocol RegistroRepositoryProtocol {
    func listar(produtoId: UUID) throws -> [RegistroDePreco]
    func listar(mercadoId: UUID) throws -> [RegistroDePreco]
    func listarPorPeriodo(inicio: Date, fim: Date) throws -> [RegistroDePreco]
    func salvar(_ registro: RegistroDePreco) throws
    func excluir(id: UUID) throws
    func ultimoPreco(produtoId: UUID, mercadoId: UUID) throws -> RegistroDePreco?
}
