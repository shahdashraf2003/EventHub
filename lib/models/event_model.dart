class EventModel {
  final String id;
  final String title;
  final String date;
  final String day;
  final String month;
  final String time;
  final String dateTimeRaw;
  final String location;
  final String address;
  final String city;
  final String state;
  final String organizer;
  final String organizerImage;
  final String coverImage;
  final String about;
  final String description;
  final double ticketPrice;
  final String currency;
  final int goingCount;
  final List<String> goingAvatars;
  final String classification;
  final String url;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.day,
    this.month = '',
    required this.time,
    this.dateTimeRaw = '',
    required this.location,
    required this.address,
    this.city = '',
    this.state = '',
    required this.organizer,
    required this.organizerImage,
    required this.coverImage,
    required this.about,
    required this.description,
    required this.ticketPrice,
    this.currency = 'USD',
    required this.goingCount,
    required this.goingAvatars,
    this.classification = '',
    this.url = '',
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final datesStart = (json['dates'] as Map?)?['start'] as Map? ?? {};
    final localDate   = (datesStart['localDate']  as String?) ?? '';
    final localTime   = (datesStart['localTime']  as String?) ?? '';
    final dateTimeRaw = (datesStart['dateTime']   as String?) ?? '';

    String dayStr   = '';
    String monthStr = '';
    String formattedDate = localDate;

    if (localDate.length >= 10) {
      final parts = localDate.split('-');
      if (parts.length == 3) {
        dayStr = parts[2];
        const monthNames = [
          '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
          'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
        ];
        final m = int.tryParse(parts[1]) ?? 0;
        monthStr     = (m > 0 && m < 13) ? monthNames[m] : '';
        formattedDate = '$monthStr $dayStr, ${parts[0]}';
      }
    }

    String formattedTime = localTime;
    if (localTime.length >= 5) {
      final tp = localTime.substring(0, 5).split(':');
      if (tp.length == 2) {
        int h        = int.tryParse(tp[0]) ?? 0;
        final min    = tp[1];
        final ampm   = h >= 12 ? 'PM' : 'AM';
        h            = h % 12;
        if (h == 0) h = 12;
        formattedTime = '$h:$min $ampm';
      }
    }

    final embedded = json['_embedded'] as Map? ?? {};
    final venues   = (embedded['venues'] as List?) ?? [];
    final venue    = venues.isNotEmpty ? venues[0] as Map : <String, dynamic>{};

    final venueName = (venue['name']                       as String?) ?? '';
    final cityName  = ((venue['city']  as Map?)?['name']   as String?) ?? '';
    final stateCode = ((venue['state'] as Map?)?['stateCode'] as String?) ?? '';
    final location  = [venueName, cityName, stateCode]
        .where((s) => s.isNotEmpty)
        .join(', ');
    final address   =
        ((venue['address'] as Map?)?['line1'] as String?) ?? location;

    final attractions  = (embedded['attractions'] as List?) ?? [];
    final attraction   = attractions.isNotEmpty ? attractions[0] as Map : <String, dynamic>{};
    final organizerName   = (attraction['name'] as String?) ?? '';
    final organizerImages = (attraction['images'] as List?) ?? [];
    final organizerImage  = organizerImages.isNotEmpty
        ? ((organizerImages[0] as Map)['url'] as String?) ?? ''
        : '';

    final images = (json['images'] as List?) ?? [];
    Map? bestImage;
    for (final img in images) {
      final m     = img as Map;
      final ratio = (m['ratio'] as String?) ?? '';
      if (ratio == '16_9') {
        if (bestImage == null ||
            ((m['width'] as int? ?? 0) > (bestImage['width'] as int? ?? 0))) {
          bestImage = m;
        }
      }
    }
    bestImage ??= images.isNotEmpty ? images[0] as Map : {};
    final coverImage = (bestImage['url'] as String?) ?? '';

    final priceRanges = (json['priceRanges'] as List?) ?? [];
    final ticketPrice = priceRanges.isNotEmpty
        ? ((priceRanges[0] as Map)['min'] as num?)?.toDouble() ?? 0.0
        : 0.0;
    final currency = priceRanges.isNotEmpty
        ? ((priceRanges[0] as Map)['currency'] as String?) ?? 'USD'
        : 'USD';

    final about = (json['info'] as String?) ??
        (json['pleaseNote'] as String?) ??
        '';

    final classifications = (json['classifications'] as List?) ?? [];
    final segment = classifications.isNotEmpty
        ? ((classifications[0] as Map)['segment'] as Map?) ?? {}
        : <String, dynamic>{};
    final classification = (segment['name'] as String?) ?? '';

    final url = (json['url'] as String?) ?? '';

    return EventModel(
      id:             (json['id']   as String?) ?? '',
      title:          (json['name'] as String?) ?? 'Untitled Event',
      date:           formattedDate,
      day:            dayStr,
      month:          monthStr,
      time:           formattedTime,
      dateTimeRaw:    dateTimeRaw,
      location:       location,
      address:        address,
      city:           cityName,
      state:          stateCode,
      organizer:      organizerName,
      organizerImage: organizerImage,
      coverImage:     coverImage,
      about:          about,
      description:    about,
      ticketPrice:    ticketPrice,
      currency:       currency,
      goingCount:     0,
      goingAvatars:   const [],
      classification: classification,
      url:            url,
    );
  }
}
