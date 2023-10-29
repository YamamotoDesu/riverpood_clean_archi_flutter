import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/pages/add_trip_screen.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/pages/my_trip_screen.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/providers/trip_provider.dart';

class MainScreen extends ConsumerWidget {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tripListNotifierProvider.notifier).loadTrips();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel App'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          const MyTripsScreen(),
          AddTripScreen(),
          Container(
            color: Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _currentPage,
        builder: (context, value, child) => BottomNavigationBar(
          currentIndex: value,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            _currentPage.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
