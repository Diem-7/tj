import 'package:flutter/material.dart';

import 'accounts/accounts_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/dashboard_style.dart';
import 'instruments/instruments_screen.dart';
import 'trades/trades_screen.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: isWide
          ? Row(
              children: [
                _SideNavigation(
                  selectedIndex: _selectedIndex,
                  onSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ],
            )
          : IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: _bottomDestinations,
            ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      decoration: const BoxDecoration(
        color: DashboardColors.backgroundBottom,
        border: Border(right: BorderSide(color: DashboardColors.border)),
      ),
      child: SafeArea(
        child: NavigationRail(
          backgroundColor: Colors.transparent,
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          extended: false,
          labelType: NavigationRailLabelType.all,
          indicatorColor: DashboardColors.neutral.withValues(alpha: 0.16),
          selectedIconTheme: const IconThemeData(
            color: DashboardColors.text,
            size: 28,
          ),
          unselectedIconTheme: const IconThemeData(
            color: DashboardColors.mutedText,
            size: 26,
          ),
          selectedLabelTextStyle: const TextStyle(
            color: DashboardColors.text,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelTextStyle: const TextStyle(
            color: DashboardColors.mutedText,
          ),
          leading: const Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 34),
            child: Icon(
              Icons.stacked_line_chart,
              color: DashboardColors.neutral,
              size: 34,
            ),
          ),
          destinations: _railDestinations,
        ),
      ),
    );
  }
}

const _screens = [
  DashboardScreen(),
  AccountsScreen(),
  InstrumentsScreen(),
  TradesScreen(),
];

const _railDestinations = [
  NavigationRailDestination(
    icon: Icon(Icons.dashboard_outlined),
    selectedIcon: Icon(Icons.dashboard),
    label: Text('Dashboard'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.account_balance_wallet_outlined),
    selectedIcon: Icon(Icons.account_balance_wallet),
    label: Text('Konten'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.show_chart_outlined),
    selectedIcon: Icon(Icons.show_chart),
    label: Text('Instrumente'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.receipt_long_outlined),
    selectedIcon: Icon(Icons.receipt_long),
    label: Text('Trades'),
  ),
];

const _bottomDestinations = [
  NavigationDestination(
    icon: Icon(Icons.dashboard_outlined),
    selectedIcon: Icon(Icons.dashboard),
    label: 'Dashboard',
  ),
  NavigationDestination(
    icon: Icon(Icons.account_balance_wallet_outlined),
    selectedIcon: Icon(Icons.account_balance_wallet),
    label: 'Konten',
  ),
  NavigationDestination(
    icon: Icon(Icons.show_chart_outlined),
    selectedIcon: Icon(Icons.show_chart),
    label: 'Instrumente',
  ),
  NavigationDestination(
    icon: Icon(Icons.receipt_long_outlined),
    selectedIcon: Icon(Icons.receipt_long),
    label: 'Trades',
  ),
];
