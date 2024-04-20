// modely.dart
class Forecast {
  final int date;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final int windDirection;
  final double windGusts;
  final double pressure;
  final double precipitation;
  final int character;

  Forecast({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
    required this.pressure,
    required this.precipitation,
    required this.character,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['date'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      windSpeed: json['wind_speed'],
      windDirection: json['wind_direction'],
      windGusts: json['wind_gusts'],
      pressure: json['pressure'],
      precipitation: json['precipitation'],
      character: json['character'],
    );
  }
}

class HTTPValidationError {
  final List<ValidationError> detail;

  HTTPValidationError({required this.detail});

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) {
    return HTTPValidationError(
      detail: List<ValidationError>.from(
          json['detail'].map((data) => ValidationError.fromJson(data))),
    );
  }
}

class ValidationError {
  final List<dynamic> loc;
  final String msg;
  final String type;

  ValidationError({
    required this.loc,
    required this.msg,
    required this.type,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      loc: List<dynamic>.from(json['loc']),
      msg: json['msg'],
      type: json['type'],
    );
  }
}
