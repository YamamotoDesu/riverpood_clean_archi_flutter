// ignore_for_file: public_member_api_docs, sort_constructors_first
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
