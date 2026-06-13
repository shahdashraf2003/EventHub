class EventModel {
  final String id;
  final String title;
  final String date;
  final String day;
  final String time;
  final String location;
  final String address;
  final String organizer;
  final String organizerImage;
  final String coverImage;
  final String about;
  final double ticketPrice;
  final int goingCount;
  final List<String> goingAvatars;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.day,
    required this.time,
    required this.location,
    required this.address,
    required this.organizer,
    required this.organizerImage,
    required this.coverImage,
    required this.about,
    required this.ticketPrice,
    required this.goingCount,
    required this.goingAvatars, required String description,
  });
}
