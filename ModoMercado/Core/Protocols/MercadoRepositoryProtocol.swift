import Foundation

protocol MercadoRepositoryProtocol {
    func listar() throws -> [Mercado]
    func salvar(_ mercado: Mercado) throws
    func excluir(id: UUID) throws
}
