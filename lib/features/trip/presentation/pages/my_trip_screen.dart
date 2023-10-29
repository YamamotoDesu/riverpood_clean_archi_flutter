import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/providers/trip_provider.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/widgets/custom_search_bar.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/widgets/travel_card.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripList = ref.watch(tripListNotifierProvider);
    print('tripList: $tripList');

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          CustomSearchBar(),
          tripList.isEmpty
              ? const Text('No trips to display')
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tripList.length,
                  itemBuilder: (context, index) {
                    final trip = tripList[index];
                    return TravelCard(
                      imageUrl: trip.pictures.isNotEmpty
                          ? Uri.parse(
                                  '${trip.pictures.first}?random=${index + 1}}')
                              .toString()
                          : '',
                      title: trip.title,
                      description: trip.description,
                      date: DateFormat('dd/MM/yyyy').format(trip.date),
                      location: trip.location,
                      onDelete: () {
                        ref
                            .read(tripListNotifierProvider.notifier)
                            .removeTrip(index + 1);
                        ref.read(tripListNotifierProvider.notifier).loadTrips();
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}
