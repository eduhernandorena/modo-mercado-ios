import Foundation

protocol ProdutoRepositoryProtocol {
    func listar() throws -> [Produto]
    func buscar(por termo: String) throws -> [Produto]
    func salvar(_ produto: Produto) throws
    func atualizar(_ produto: Produto) throws
    func excluir(id: UUID) throws
    func possuiRegistros(produtoId: UUID) throws -> Bool
}
