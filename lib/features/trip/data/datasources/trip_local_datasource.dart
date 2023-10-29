import 'package:hive/hive.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/models/trip_model.dart';

class TripLocalDataSource {
  final Box<TripModel> tripBox;

  TripLocalDataSource(this.tripBox);

  List<TripModel> getTrips() {
    print('*** tripBox.values.toList(): ${tripBox.values.toList()}');
    return tripBox.values.toList();
  }

  void addTrip(TripModel trip) {
    tripBox.add(trip);
  }

  void deleteTrip(int index) {
    final key = tripBox.keyAt(index);
    tripBox.delete(key);
  }
}
