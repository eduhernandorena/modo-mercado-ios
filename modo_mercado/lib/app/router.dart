import 'package:go_router/go_router.dart';
import '../features/produtos/presentation/produtos_list_view.dart';
import '../features/produtos/presentation/produto_form_view.dart';
import '../features/registros/presentation/registro_form_view.dart';
import '../features/lista_de_compras/presentation/listas_view.dart';
import '../features/dashboard/presentation/dashboard_view.dart';
import 'app.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardView(),
        ),
        GoRoute(
          path: '/produtos',
          builder: (context, state) => const ProdutosListView(),
          routes: [
            GoRoute(
              path: 'novo',
              builder: (context, state) => const ProdutoFormView(),
            ),
          ],
        ),
        GoRoute(
          path: '/registros/novo',
          builder: (context, state) => const RegistroFormView(),
        ),
        GoRoute(
          path: '/listas',
          builder: (context, state) => const ListasView(),
        ),
      ],
    ),
  ],
);
