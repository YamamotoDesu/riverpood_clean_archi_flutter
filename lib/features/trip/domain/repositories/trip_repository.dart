import 'package:dartz/dartz.dart';
import 'package:riverpood_clean_archi_flutter/core.error/failures.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getTrips();
  Future<void> addTrips(Trip trip);
  Future<void> deleteTrip(int index);
}
