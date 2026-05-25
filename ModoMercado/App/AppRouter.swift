import SwiftUI

// MARK: - AppTab

/// Representa as abas principais da aplicação.
enum AppTab: Hashable, CaseIterable {
    case produtos
    case registros
    case listas
    case dashboard
    case comparacao

    var title: String {
        switch self {
        case .produtos:    return "Produtos"
        case .registros:   return "Registros"
        case .listas:      return "Listas"
        case .dashboard:   return "Dashboard"
        case .comparacao:  return "Comparação"
        }
    }

    var systemImage: String {
        switch self {
        case .produtos:    return "cart"
        case .registros:   return "tag"
        case .listas:      return "list.bullet"
        case .dashboard:   return "chart.bar"
        case .comparacao:  return "arrow.left.arrow.right"
        }
    }
}

// MARK: - AppRouter

/// Raiz de navegação da aplicação. Gerencia o TabView com as cinco abas principais.
struct AppRouter: View {

    @State private var selectedTab: AppTab = .produtos

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private func tabContent(for tab: AppTab) -> some View {
        switch tab {
        case .produtos:
            NavigationStack {
                // ProdutosListView() — será conectado na tarefa 12.1
                placeholderView(title: "Produtos")
            }
        case .registros:
            NavigationStack {
                // RegistroFormView() — será conectado na tarefa 12.1
                placeholderView(title: "Registros")
            }
        case .listas:
            NavigationStack {
                // ListasView() — será conectado na tarefa 12.1
                placeholderView(title: "Listas de Compras")
            }
        case .dashboard:
            NavigationStack {
                // DashboardView() — será conectado na tarefa 12.1
                placeholderView(title: "Dashboard")
            }
        case .comparacao:
            NavigationStack {
                // ComparacaoView() — será conectado na tarefa 12.1
                placeholderView(title: "Comparação")
            }
        }
    }

    // MARK: - Placeholder

    private func placeholderView(title: String) -> some View {
        ContentUnavailableView(
            title,
            systemImage: "hammer",
            description: Text("Em construção")
        )
        .navigationTitle(title)
    }
}

// MARK: - Preview

#Preview {
    AppRouter()
}
