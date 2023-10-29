import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/datasources/trip_local_datasource.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/models/trip_model.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/repositories/trip_repository.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/repositories/trip_repository.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/usecases/add_trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/usecases/delete_trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/usecases/get_trips.dart';

final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final Box<TripModel> tripBox = Hive.box('trips');
  return TripLocalDataSource(tripBox);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  return TripRepositryImpl(localDataSource);
});

final addTripProvider = Provider<AddTrip>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return AddTrip(repository);
});

final getTripProvider = Provider<GetTrips>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return GetTrips(repository);
});

final deleteTripProvider = Provider<DeleteTrip>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return DeleteTrip(repository);
});

final tripListNotifierProvider =
    StateNotifierProvider<TripListNotifier, List<Trip>>((ref) {
  final getTrips = ref.read(getTripProvider);
  final addTrip = ref.read(addTripProvider);
  final deleteTrip = ref.read(deleteTripProvider);

  return TripListNotifier(getTrips, addTrip, deleteTrip);
});

class TripListNotifier extends StateNotifier<List<Trip>> {
  final GetTrips _getTrips;
  final AddTrip _addTrip;
  final DeleteTrip _deleteTrip;

  TripListNotifier(
    this._getTrips,
    this._addTrip,
    this._deleteTrip,
  ) : super([]);

  Future<void> addNewTrip(Trip trip) async {
    await _addTrip(trip);
  }

  Future<void> removeTrip(int index) async {
    print('*** index: $index');
    await _deleteTrip(index);
  }

  Future<void> loadTrips() async {
    final tripsOrFailure = await _getTrips();
    tripsOrFailure.fold((error) => state = [], (trips) {
      print('*** trips: $trips');
      state = trips;
    });
  }
}
