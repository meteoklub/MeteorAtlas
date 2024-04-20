import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meteoapp/repositories/forecast_api_provider.dart';

import '../../../domain/models/location_model.dart';
import '../../domain/models/forecast_model.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final ForecastApiProvider repository;

  WeatherBloc({
    required this.repository,
  }) : super(WeatherInitialState()) {
    on<GetWeather>(_fetchWeather);
  }

  FutureOr<void> _fetchWeather(
      GetWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadingState());

    try {
      final currentLocation = event.mode;
      if (currentLocation != null) {
        final dailyForecast = await repository.getDailyForecast(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        final hourlyForecast = await repository.getHourlyForecast(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        emit(WeatherLoadedState(dailyForecast, hourlyForecast));
      } else {
        emit(const WeatherErrorState('Location not available'));
      }
    } catch (e) {
      emit(WeatherErrorState('Failed to load daily forecast: $e'));
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      print(key + value);
    });
    return null;
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    if (state.props.isNotEmpty) {
      return {};
    }
    return null;
  }
}
