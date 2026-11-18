import 'package:flutter/material.dart';

import 'main_widget.dart';

/// The root route owns the tab bar. Push deeper routes on the root Navigator
/// (Navigator.of(context, rootNavigator: true)) to cover the entire shell.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            _TabPlaceholder(title: 'Today'),
            _TabPlaceholder(title: 'Habit'),
            _TabPlaceholder(title: 'More'),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index != _selectedIndex) {
            setState(() => _selectedIndex = index);
          }
        },
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        '$title placeholder',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
