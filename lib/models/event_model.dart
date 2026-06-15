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
  final String description;
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
    required this.description,
    required this.ticketPrice,
    required this.goingCount,
    required this.goingAvatars,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final datesStart = (json['dates'] as Map?)?['start'] as Map? ?? {};
    final localDate = (datesStart['localDate'] as String?) ?? '';
    final localTime = (datesStart['localTime'] as String?) ?? '';

    String day = '';
    String month = '';
    String formattedDate = localDate;
    if (localDate.length >= 10) {
      final parts = localDate.split('-');
      if (parts.length == 3) {
        day = parts[2];
        const monthNames = [
          '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
          'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
        ];
        final m = int.tryParse(parts[1]) ?? 0;
        month = m > 0 && m < 13 ? monthNames[m] : '';
        formattedDate = '$month $day, ${parts[0]}';
      }
    }
    String formattedTime = localTime;
    if (localTime.length >= 5) {
      final tp = localTime.substring(0, 5).split(':');
      if (tp.length == 2) {
        int h = int.tryParse(tp[0]) ?? 0;
        final min = tp[1];
        final ampm = h >= 12 ? 'PM' : 'AM';
        h = h % 12;
        if (h == 0) h = 12;
        formattedTime = '$h:$min $ampm';
      }
    }

    final embedded = json['_embedded'] as Map? ?? {};
    final venues = (embedded['venues'] as List?) ?? [];
    final venue = venues.isNotEmpty ? venues[0] as Map : {};
    final venueName = (venue['name'] as String?) ?? '';
    final city = ((venue['city'] as Map?)?['name'] as String?) ?? '';
    final state = ((venue['state'] as Map?)?['stateCode'] as String?) ?? '';
    final location = [venueName, city, state]
        .where((s) => s.isNotEmpty)
        .join(', ');
    final address =
        ((venue['address'] as Map?)?['line1'] as String?) ?? location;

    final attractions = (embedded['attractions'] as List?) ?? [];
    final attraction =
        attractions.isNotEmpty ? attractions[0] as Map : {};
    final organizerName = (attraction['name'] as String?) ?? '';
    final organizerImages = (attraction['images'] as List?) ?? [];
    final organizerImage = organizerImages.isNotEmpty
        ? (organizerImages[0] as Map)['url'] as String? ?? ''
        : '';

    final images = (json['images'] as List?) ?? [];
    Map? bestImage;
    for (final img in images) {
      final ratio = (img as Map)['ratio'] as String? ?? '';
      if (ratio == '16_9') {
        if (bestImage == null ||
            ((img['width'] as int? ?? 0) >
                (bestImage['width'] as int? ?? 0))) {
          bestImage = img;
        }
      }
    }
    bestImage ??= images.isNotEmpty ? images[0] as Map : {};
    final coverImage = (bestImage['url'] as String?) ?? '';
    final priceRanges = (json['priceRanges'] as List?) ?? [];
    final ticketPrice = priceRanges.isNotEmpty
        ? ((priceRanges[0] as Map)['min'] as num?)?.toDouble() ?? 0.0
        : 0.0;

    final about = (json['info'] as String?) ??
        (json['pleaseNote'] as String?) ??
        '';

    return EventModel(
      id: (json['id'] as String?) ?? '',
      title: (json['name'] as String?) ?? 'Untitled Event',
      date: formattedDate,
      day: day,
      time: formattedTime,
      location: location,
      address: address,
      organizer: organizerName,
      organizerImage: organizerImage,
      coverImage: coverImage,
      about: about,
      description: about,
      ticketPrice: ticketPrice,
      goingCount: 0,
      goingAvatars: const [],
    );
  }
}
