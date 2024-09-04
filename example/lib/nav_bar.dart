import 'package:example/modules/list_view/screens/list_view_screen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() => currentPageIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_rounded),
            label: 'List',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Grid',
          ),
          NavigationDestination(
            icon: Icon(Icons.message_rounded),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.line_style_outlined),
            label: 'Advanced',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          const ListViewScreen(),
          Container(
            alignment: Alignment.center,
            child: const Text('Search'),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text('Favorites'),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
