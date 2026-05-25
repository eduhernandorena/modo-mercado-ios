import Foundation

enum AppError: LocalizedError {
    // MARK: - Validação
    case campoObrigatorioAusente(campo: String)
    case valorInvalido(campo: String, motivo: String)
    case produtoSemPreco(nomeProduto: String)

    // MARK: - Persistência
    case falhaAoSalvar(entidade: String, causa: Error)
    case falhaAoLer(entidade: String, causa: Error)
    case falhaAoExcluir(entidade: String, causa: Error)
    case dadosCorrempidos

    // MARK: - Negócio
    case produtoPossuiRegistros(nomeProduto: String)
    case listaVazia

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .campoObrigatorioAusente(let campo):
            return "O campo '\(campo)' é obrigatório e não pode estar vazio."
        case .valorInvalido(let campo, let motivo):
            return "O campo '\(campo)' possui um valor inválido: \(motivo)."
        case .produtoSemPreco(let nomeProduto):
            return "O produto '\(nomeProduto)' não pode ser adicionado pois não possui nenhum preço registrado."
        case .falhaAoSalvar(let entidade, let causa):
            return "Falha ao salvar \(entidade): \(causa.localizedDescription)"
        case .falhaAoLer(let entidade, let causa):
            return "Falha ao ler \(entidade): \(causa.localizedDescription)"
        case .falhaAoExcluir(let entidade, let causa):
            return "Falha ao excluir \(entidade): \(causa.localizedDescription)"
        case .dadosCorrempidos:
            return "Os dados do aplicativo estão corrompidos e não puderam ser carregados."
        case .produtoPossuiRegistros(let nomeProduto):
            return "O produto '\(nomeProduto)' possui registros de preço vinculados. Ao excluí-lo, todos os registros também serão removidos."
        case .listaVazia:
            return "A lista de compras está vazia."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .campoObrigatorioAusente:
            return "Preencha o campo indicado antes de continuar."
        case .valorInvalido:
            return "Corrija o valor do campo indicado e tente novamente."
        case .produtoSemPreco:
            return "Registre ao menos um preço para este produto antes de adicioná-lo à lista."
        case .falhaAoSalvar, .falhaAoLer, .falhaAoExcluir:
            return "Tente novamente. Se o problema persistir, reinicie o aplicativo."
        case .dadosCorrempidos:
            return "O aplicativo será iniciado com um estado vazio. Seus dados anteriores não puderam ser recuperados."
        case .produtoPossuiRegistros:
            return "Confirme a exclusão para remover o produto e todos os seus registros vinculados."
        case .listaVazia:
            return "Adicione itens à lista antes de continuar."
        }
    }
}
