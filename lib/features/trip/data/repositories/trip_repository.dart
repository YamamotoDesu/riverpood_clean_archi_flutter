import 'package:dartz/dartz.dart';
import 'package:riverpood_clean_archi_flutter/core.error/failures.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/datasources/trip_local_datasource.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/models/trip_model.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/repositories/trip_repository.dart';

class TripRepositryImpl implements TripRepository {
  final TripLocalDataSource localDataSource;

  TripRepositryImpl(this.localDataSource);

  @override
  Future<void> addTrips(Trip trip) async {
    final tripModel = TripModel.fromEntity(trip);
    localDataSource.addTrip(tripModel);
  }

  @override
  Future<void> deleteTrip(int index) async {
    localDataSource.deleteTrip(index);
  }

  @override
  Future<Either<Failure, List<Trip>>> getTrips() async {
    try {
      final tripModels = localDataSource.getTrips();
      List<Trip> res =
          tripModels.map((tripModel) => tripModel.toEntity()).toList();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
