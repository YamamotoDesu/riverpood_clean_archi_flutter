import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';

abstract class TripRepository {
  Future<Trip> getTrips();
  Future<void> addTrips(Trip trip);
  Future<void> deleteTrip(int index);
}
