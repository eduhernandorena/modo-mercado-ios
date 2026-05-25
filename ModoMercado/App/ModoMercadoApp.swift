import SwiftUI
import SwiftData

@main
struct ModoMercadoApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppRouter()
                .modelContainer(persistenceController.container)
        }
    }
}
