import Foundation
import SwiftData

/// Singleton que encapsula o `ModelContainer` do SwiftData.
///
/// Centraliza a configuração do schema e das entidades persistidas,
/// permitindo que o container seja reutilizado em testes e em produção.
///
/// - Requirements: 7.1, 7.2
final class PersistenceController {

    // MARK: - Singleton

    static let shared = PersistenceController()

    // MARK: - Container

    let container: ModelContainer

    // MARK: - Schema

    static var schema: Schema {
        Schema([
            ProdutoEntity.self,
            RegistroEntity.self,
            MercadoEntity.self,
            ListaEntity.self,
            ItemEntity.self,
        ])
    }

    // MARK: - Init

    /// Inicializa o controller com armazenamento persistente no disco (padrão de produção).
    init(inMemory: Bool = false) {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        do {
            container = try ModelContainer(
                for: PersistenceController.schema,
                configurations: configuration
            )
        } catch {
            // Requirement 7.7: falha ao inicializar o container é fatal em produção.
            fatalError("Falha ao inicializar ModelContainer: \(error.localizedDescription)")
        }
    }

    // MARK: - Preview / Test Helper

    /// Container em memória para uso em Previews e testes unitários.
    static var preview: PersistenceController {
        PersistenceController(inMemory: true)
    }
}
