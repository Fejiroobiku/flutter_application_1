import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_bro/constants/app_colors.dart';
import 'package:here_bro/src/presentation/bloc/event/event_bloc.dart';
import 'package:here_bro/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:here_bro/src/presentation/bloc/auth/auth_state.dart';
import 'package:here_bro/pages/dashboard_page.dart';
import 'package:here_bro/pages/profile_page.dart';
import 'package:here_bro/src/presentation/pages/events_page.dart';


/// Responsive main app shell with adaptive layout.
/// 
/// Adapts UI based on screen size:
/// - Small screens (≤ 5.5"): Compact layout, single column
/// - Large screens (≥ 6.7"): Spacious layout, multi-column where appropriate
/// 
/// Handles orientation changes gracefully with Flexible/Expanded widgets.
class MainAppShell extends StatefulWidget {
  final int initialTab;

  const MainAppShell({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTab;
    _loadEventsOnInit();
  }

  void _loadEventsOnInit() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<EventBloc>().add(const LoadEvents());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isSmallScreen = _isSmallScreen(screenWidth);
        final isLandscape = screenWidth > screenHeight;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                _buildAppBar(context, isSmallScreen),
                // Main Content
                Expanded(
                  child: _buildMainContent(
                    isSmallScreen,
                    isLandscape,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isLandscape && !isSmallScreen
              ? null
              : _buildBottomNavBar(isSmallScreen),
        );
      },
    );
  }

  /// Build responsive app bar with adaptive sizing.
  Widget _buildAppBar(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 20,
        vertical: isSmallScreen ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'EventEase',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald600,
                  fontSize: isSmallScreen ? 20 : 24,
                ),
          ),
          Row(
            children: [
              _buildIconButton(
                icon: Icons.notifications_outlined,
                onPressed: () {},
                isSmall: isSmallScreen,
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              _buildIconButton(
                icon: Icons.menu,
                onPressed: () {},
                isSmall: isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build main content area with responsive layout.
  Widget _buildMainContent(bool isSmallScreen, bool isLandscape) {
    final pages = [
      const EventsPage(userEventsOnly: false),
      const EventsPage(userEventsOnly: true),
      const DashboardPage(),
      const ProfilePage(),
    ];

    if (isLandscape && !isSmallScreen) {
      return _buildLandscapeLayout(pages, isSmallScreen);
    }

    return pages[_currentTabIndex];
  }

  /// Build landscape layout with side navigation and content.
  Widget _buildLandscapeLayout(
    List<Widget> pages,
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        // Side Navigation
        Container(
          width: isSmallScreen ? 60 : 100,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.event_outlined,
                label: 'All Events',
                isSmall: isSmallScreen,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.bookmark_outlined,
                label: 'My Events',
                isSmall: isSmallScreen,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                isSmall: isSmallScreen,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outlined,
                label: 'Profile',
                isSmall: isSmallScreen,
              ),
            ],
          ),
        ),
        // Content Area
        Expanded(
          child: pages[_currentTabIndex],
        ),
      ],
    );
  }

  /// Build bottom navigation bar with adaptive sizing.
  Widget _buildBottomNavBar(bool isSmallScreen) {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.emerald600,
      unselectedItemColor: AppColors.gray400,
      iconSize: isSmallScreen ? 20 : 28,
      selectedFontSize: isSmallScreen ? 10 : 12,
      unselectedFontSize: isSmallScreen ? 9 : 11,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          label: 'All Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outlined),
          label: 'My Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'Profile',
        ),
      ],
    );
  }

  /// Build navigation item for landscape layout.
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSmall,
  }) {
    final isSelected = _currentTabIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isSmall ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.emerald50 : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.emerald600 : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isSmall ? 20 : 28,
              color: isSelected ? AppColors.emerald600 : AppColors.gray400,
            ),
            if (!isSmall) ...[
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? AppColors.emerald600 : AppColors.gray400,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build icon button with adaptive sizing.
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isSmall,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: isSmall ? 20 : 24,
      padding: EdgeInsets.all(isSmall ? 6 : 8),
      constraints: BoxConstraints(
        minWidth: isSmall ? 36 : 48,
        minHeight: isSmall ? 36 : 48,
      ),
    );
  }

  /// Determine if screen is small (≤ 5.5").
  /// 
  /// Uses diagonal calculation to estimate actual screen size.
  /// Fallback to width-based check if diagonal unavailable.
  bool _isSmallScreen(double screenWidth) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    // Calculate diagonal in inches
    final diagonalInches = (mediaQuery.size.diagonal) / devicePixelRatio / 160;

    // Use diagonal if available, otherwise use width heuristic
    if (diagonalInches > 0) {
      return diagonalInches <= 5.5;
    }

    // Fallback: consider screen small if width ≤ 400dp
    return screenWidth <= 400;
  }
}

/// Extension to calculate screen diagonal.
extension SizeDiagonal on Size {
  double get diagonal => sqrt(width * width + height * height);
}
