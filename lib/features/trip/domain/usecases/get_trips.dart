import 'package:dartz/dartz.dart';
import 'package:riverpood_clean_archi_flutter/core.error/failures.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;

  GetTrips(this.repository);

  Future<Either<Failure, List<Trip>>> call() {
    return repository.getTrips();
  }
}
