class AtlasModel {
  final int id;
  final int insertTimestamp;
  final String nameCzech;
  final String nameLatin;
  final String description;
  final String currentWeatherDescription;
  final String futureWeatherDescription;
  final List<int> severeWeatherTypes;
  final String severeWeatherDescription;
  final String fullImagePath;
  final String thumbImagePath;

  AtlasModel({
    required this.id,
    required this.insertTimestamp,
    required this.nameCzech,
    required this.nameLatin,
    required this.description,
    required this.currentWeatherDescription,
    required this.futureWeatherDescription,
    required this.severeWeatherTypes,
    required this.severeWeatherDescription,
    required this.fullImagePath,
    required this.thumbImagePath,
  });

  factory AtlasModel.fromJson(Map<String, dynamic> json) {
    return AtlasModel(
      id: json['id'],
      insertTimestamp: json['insert_timestamp'],
      nameCzech: json['name_czech'],
      nameLatin: json['name_latin'],
      description: json['description'],
      currentWeatherDescription: json['current_weather_description'],
      futureWeatherDescription: json['future_weather_description'],
      severeWeatherTypes: List<int>.from(json['severe_weather_types']),
      severeWeatherDescription: json['severe_weather_description'],
      fullImagePath: json['full_image_path'],
      thumbImagePath: json['thumb_image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['insert_timestamp'] = insertTimestamp;
    data['name_czech'] = nameCzech;
    data['name_latin'] = nameLatin;
    data['description'] = description;
    data['current_weather_description'] = currentWeatherDescription;
    data['future_weather_description'] = futureWeatherDescription;
    data['severe_weather_types'] = severeWeatherTypes;
    data['severe_weather_description'] = severeWeatherDescription;
    data['full_image_path'] = fullImagePath;
    data['thumb_image_path'] = thumbImagePath;
    return data;
  }
}
