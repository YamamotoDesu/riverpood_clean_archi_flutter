# [riverpood_clean_archi_flutter](https://www.youtube.com/watch?v=fT-eOgl_jhk&list=WL&index=1)

## Future:
Riverpood : Riverpod makes working with asynchronous code.

Clean Architecture : In this tutorial, we're combine clean archi with DDD.

Hive: Learn how to set up, read, write, and manage a local Hive database within a Flutter application.

## Packages 

pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_riverpod: ^2.4.4
  path_provider: ^2.1.1
  dartz: ^0.10.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^2.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

## Project Structures
```text
- lib
  - features
    - trip
      - data
        - datasources
        - models
        - repositories
      - domain
        - entities
        - repositories
        - usecases
      - presentation
        - pages
        - providers
        - widgets
```

## Domain Layer 

### Structure
```text
      - domain
        - entities
          - trip.dart
        - repositories
          - trip_repository.dart
        - usecases
          - add_trip.dart
          - delete_trip.dart
          - get_trips.dart
```

### Examples
lib/features/trip/domain/entities/trip.dart
```dart
class Trip {
  final String title;
  final List<String> pictures;
  final String description;
  final DateTime date;
  final String location;

  Trip({
    required this.title,
    required this.pictures,
    required this.description,
    required this.date,
    required this.location,
  });
}
```

lib/features/trip/domain/repositories/trip_repository.dart
```dart
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';

abstract class TripRepository {
  Future<Trip> getTrips();
  Future<void> addTrips(Trip trip);
  Future<void> deleteTrip(int index);
}
```

lib/features/trip/domain/usecases/add_trip.dart
```dart
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/repositories/trip_repository.dart';

class AddTrip {
  final TripRepository repository;

  AddTrip(this.repository);

  Future<void> call(Trip trip) {
    return repository.addTrips(trip);
  }
}
```

lib/features/trip/domain/usecases/delete_trip.dart
```dart
import 'package:riverpood_clean_archi_flutter/features/trip/domain/repositories/trip_repository.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip(this.repository);

  Future<void> call(int index) {
    return repository.deleteTrip(index);
  }
}
```

lib/features/trip/domain/usecases/get_trips.dart
```dart
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;

  GetTrips(this.repository);

  Future<Trip> call() {
    return repository.getTrips();
  }
}
```

## Data Layer 

### Structure
```text
      - data
        - datasources
          - trip_local_datasource.dart
        - models
          - trip_model.dart
          - trip_model.g.dart
        - repositories
          - trip_repository.dart
```

### Example
lib/features/trip/data/datasources/trip_local_datasource.dart
```dart
import 'package:hive/hive.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/data/models/trip_model.dart';

class TripLocalDataSource {
  final Box<TripModel> tripBox;

  TripLocalDataSource(this.tripBox);

  List<TripModel> getTrips() {
    return tripBox.values.toList();
  }

  void addTrip(TripModel trip) {
    tripBox.add(trip);
  }

  void deleteTrip(int index) {
    tripBox.delete(index);
  }
}
```

lib/features/trip/data/models/trip_model.dart
```dart
import 'package:hive/hive.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 0)
class TripModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final List<String> pictures;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String location;

  TripModel({
    required this.title,
    required this.pictures,
    required this.description,
    required this.date,
    required this.location,
  });

  // Converstion from Entity to Model
  factory TripModel.fromEntity(Trip trip) => TripModel(
        title: trip.title,
        pictures: trip.pictures,
        description: trip.description,
        date: trip.date,
        location: trip.location,
      );

  // Converstion from Model to Entity
  Trip toEntity() => Trip(
        title: title,
        pictures: pictures,
        description: description,
        date: date,
        location: location,
      );
}
```

lib/features/trip/data/repositories/trip_repository.dart
```dart
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
  Future<List<Trip>> getTrips() async {
    final tripModels = localDataSource.getTrips();
    List<Trip> res =
        tripModels.map((tripModel) => tripModel.toEntity()).toList();
    return res;
  }
}
```
