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
