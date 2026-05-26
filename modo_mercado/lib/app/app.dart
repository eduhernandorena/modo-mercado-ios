import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';

class ModoMercadoApp extends StatelessWidget {
  const ModoMercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Modo Mercado',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/produtos')) return 1;
    if (location.startsWith('/registros')) return 2;
    if (location.startsWith('/listas')) return 3;
    return 0; // dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0: context.go('/');
            case 1: context.go('/produtos');
            case 2: context.go('/registros/novo');
            case 3: context.go('/listas');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Produtos'),
          NavigationDestination(icon: Icon(Icons.add_circle), label: 'Registrar'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Listas'),
        ],
      ),
    );
  }
}
