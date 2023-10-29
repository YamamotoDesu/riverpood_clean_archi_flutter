# [riverpood_clean_archi_flutter](https://www.youtube.com/watch?v=fT-eOgl_jhk&list=WL&index=1)

<img width="300" alt="スクリーンショット 2023-10-29 19 11 09" src="https://github.com/YamamotoDesu/riverpood_clean_archi_flutter/assets/47273077/cdd9608a-1f9a-46b1-8803-fad43f926b92">

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
import 'package:dartz/dartz.dart';
import 'package:riverpood_clean_archi_flutter/core.error/failures.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getTrips();
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
```


## Prentation Layer 
### Structure 
```dart
      - presentation
        - pages
          - add_trip_screen.dart
          - main_screen.dart
          - my_trip_screen.dart
        - providers
          - trip_provider.dart
        - widgets
          - custom_search_bar.dart
          - travel_card.dart
```

### Example

lib/features/trip/presentation/providers/trip_provider.dart
```dart
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

```

lib/main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the box.
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(TripModelAdapter());
  await Hive.openBox<TripModel>('trips');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      home: MainScreen(),
    );
  }
}
```

lib/features/trip/presentation/pages/add_trip_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/domain/entities/trip.dart';
import 'package:riverpood_clean_archi_flutter/features/trip/presentation/providers/trip_provider.dart';

class AddTripScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'City');
  final _descController = TextEditingController(text: 'Best city ever');
  final _locationController = TextEditingController(text: 'Paris');
  final _pictureController = TextEditingController(
      text: Uri.parse('https://picsum.photos/200/300').toString());

  List<String> pictures = [];

  AddTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _pictureController,
            decoration: const InputDecoration(
              labelText: 'Picture',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a picture';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              pictures.add(_pictureController.text);
              if (_formKey.currentState!.validate()) {
                final newTrip = Trip(
                  title: _titleController.text,
                  pictures: pictures,
                  description: _descController.text,
                  date: DateTime.now(),
                  location: _locationController.text,
                );
                ref.read(tripListNotifierProvider.notifier).addNewTrip(newTrip);
                ref.read(tripListNotifierProvider.notifier).loadTrips();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```
