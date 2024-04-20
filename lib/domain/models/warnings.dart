class Geopoint {
  final double lat;
  final double lon;

  Geopoint({
    required this.lat,
    required this.lon,
  });

  factory Geopoint.fromJson(Map<String, dynamic> json) {
    return Geopoint(
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class WarningTranslation {
  final bool automatic;
  final String text;

  WarningTranslation({
    required this.automatic,
    required this.text,
  });

  factory WarningTranslation.fromJson(Map<String, dynamic> json) {
    return WarningTranslation(
      automatic: json['automatic'] ?? false,
      text: json['text'],
    );
  }
}

class Message {
  final String message;

  Message({required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
    );
  }
}

class LongWarning {
  final int id;
  final int dateStart;
  final int dateEnd;
  final int dateIssued;
  final int severity;
  final List<Type> types;
  final List<Geopoint> region;
  final Content content;

  LongWarning({
    required this.id,
    required this.dateStart,
    required this.dateEnd,
    required this.dateIssued,
    required this.severity,
    required this.types,
    required this.region,
    required this.content,
  });

  factory LongWarning.fromJson(Map<String, dynamic> json) {
    return LongWarning(
      id: json['id'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      dateIssued: json['date_issued'],
      severity: json['severity'],
      types: List<Type>.from(json['types'].map((data) => Type.fromJson(data))),
      region: List<Geopoint>.from(
          json['region'].map((data) => Geopoint.fromJson(data))),
      content: Content.fromJson(json['content']),
    );
  }
}

class Content {
  final bool automatic;
  final String text;

  Content({
    required this.automatic,
    required this.text,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      automatic: json['automatic'] ?? false,
      text: json["en"]['text'],
    );
  }
}

class Type {
  final int code;
  final int probability;

  Type({
    required this.code,
    required this.probability,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      code: json['code'],
      probability: json['probability'],
    );
  }
}
