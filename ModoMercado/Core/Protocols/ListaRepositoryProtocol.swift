import Foundation

protocol ListaRepositoryProtocol {
    func listar() throws -> [ListaDeCompras]
    func salvar(_ lista: ListaDeCompras) throws
    func atualizar(_ lista: ListaDeCompras) throws
    func excluir(id: UUID) throws
}
