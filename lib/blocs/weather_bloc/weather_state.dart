part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final List<Forecast> forecastList;
  final List<Forecast> forecastHourlyList;

  const WeatherLoadedState(this.forecastList, this.forecastHourlyList);

  @override
  List<Object?> get props => [forecastList];
}

class WeatherErrorState extends WeatherState {
  final String errorMessage;

  const WeatherErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
