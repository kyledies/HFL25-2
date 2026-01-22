import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  final String location;

  const ShellScaffold({super.key, required this.child, required this.location});

  int _indexFromLocation(String loc) {
    if (loc.startsWith('/search')) return 1;
    if (loc.startsWith('/squad')) return 2;
    if (loc.startsWith('/settings')) return 3;
    return 0; // /home
  }

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/squad');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(location);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _goToIndex(context, i),
        backgroundColor: cs.surfaceContainerHighest, // tydligare platta
        indicatorColor: cs.secondaryContainer, // markerad flik
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Squad'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
