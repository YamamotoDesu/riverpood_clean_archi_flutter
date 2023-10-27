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
