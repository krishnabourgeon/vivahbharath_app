import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_bottom_nav.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/app_icon.dart';
import 'package:vivahbharath_app/view/dashboard/home_screen.dart';
import 'package:vivahbharath_app/view/dashboard/inbox_screen.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart' show MatchesScreen;
import 'package:vivahbharath_app/view/dashboard/profile_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';

/// Main screen after login: holds the bottom navigation bar and switches
/// between the tab screens. Each tab keeps its state (scroll position,
/// selected filter, …) while you move between tabs.
class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  /// Lets a screen inside the shell switch tabs, e.g.
  /// `DashboardShell.of(context)?.goTo(DashboardTab.matches)`.
  static DashboardShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<DashboardShellState>();

  @override
  State<DashboardShell> createState() => DashboardShellState();
}

/// Tab order in the bottom bar.
abstract final class DashboardTab {
  static const home = 0;
  static const matches = 1;
  static const search = 2;
  static const inbox = 3;
  static const profile = 4;
}

class DashboardShellState extends State<DashboardShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    AppNavItem(icon: 'home', label: 'Home'),
    AppNavItem(icon: 'heart', label: 'Matches'),
    AppNavItem(icon: 'search', label: 'Search'),
    AppNavItem(icon: 'inbox_nav', label: 'Inbox', showDot: true),
    AppNavItem(icon: 'user', label: 'Profile'),
  ];

  // Root screen of each tab. IndexedStack keeps every tab alive.
  static const _pages = <Widget>[
    HomeScreen(),
    MatchesScreen(),
    SearchScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  // Each tab has its own Navigator, so pages pushed from a tab (e.g. search
  // results) open above the bottom bar instead of covering it.
  final _navKeys = List.generate(_pages.length, (_) => GlobalKey<NavigatorState>());

  int get currentIndex => _index;

  void goTo(int index) {
    if (index == _index) {
      // Tapping the current tab again returns to that tab's first screen.
      _navKeys[index].currentState?.popUntil((r) => r.isFirst);
      return;
    }
    setState(() => _index = index);
  }

  /// Android back: close a page inside the tab, else go to Home, else exit.
  void _handleBack() {
    final nav = _navKeys[_index].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    } else if (_index != DashboardTab.home) {
      goTo(DashboardTab.home);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgBottom,
        body: IndexedStack(
          index: _index,
          children: [
            for (var i = 0; i < _pages.length; i++)
              Navigator(
                key: _navKeys[i],
                onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (_) => _pages[i],
                ),
              ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          items: _items,
          currentIndex: _index,
          onTap: goTo,
        ),
      ),
    );
  }
}

/// Placeholder for tabs whose screens aren't built yet.
class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgTop, AppColors.bgBottom],
          stops: [0, 0.45],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(icon, size: 44, color: AppColors.goldDark),
              const SizedBox(height: 12),
              Text(title, style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 4),
              Text('Coming soon', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
