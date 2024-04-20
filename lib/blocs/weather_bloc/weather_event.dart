part of 'weather_bloc.dart';

abstract class WeatherEvent {}

class GetWeather extends WeatherEvent {
  final MyLocation? mode;
  GetWeather(this.mode);
}
