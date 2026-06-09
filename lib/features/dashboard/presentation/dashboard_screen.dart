import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../booking/presentation/screens/booking_history_screen.dart';
import '../../profile/presentation/bloc/profile_cubit.dart';
import 'alerts_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'services_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;
  final _profileCubit = sl<ProfileCubit>();

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  void _goToTab(int i) => setState(() => _index = i);

  void _openBooking() => context.push(AppRoutes.booking);

  void _openAlerts() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Alerts')),
          body: const AlertsTab(),
        ),
      ),
    );
  }

  void _openSupport() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support is available 24/7 at 1-800-CARE-NOW')));
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(
        onBookNurse: () => _openBooking(),
        onViewHistory: () => _goToTab(2),
        onViewRecords: () => _goToTab(2),
        onSupport: _openSupport,
        onOpenAlerts: () => _openAlerts(),
      ),
      ServicesTab(onBook: (_) => _openBooking()),
      const BookingHistoryScreen(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: BlocProvider.value(
        value: _profileCubit,
        child: IndexedStack(index: _index, children: tabs),
      ),
      bottomNavigationBar: _DashboardNavBar(currentIndex: _index, onTap: _goToTab),
    );
  }
}

class _DashboardNavBar extends StatelessWidget {
  const _DashboardNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search_rounded), label: 'Services'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
