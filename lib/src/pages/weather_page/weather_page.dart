import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meteoapp/domain/theme/consts.dart';
import 'package:meteoapp/src/components/cards/weather_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/location_bloc/location_bloc.dart';
import '../../../blocs/location_bloc/location_state.dart';
import '../../../blocs/weather_bloc/weather_bloc.dart';
import '../../../domain/models/forecast_model.dart';

class WeatherListPage extends StatefulWidget {
  const WeatherListPage({super.key});
  static const routeName = "/weatherList";

  @override
  State<WeatherListPage> createState() => _WeatherListPageState();
}

class _WeatherListPageState extends State<WeatherListPage> {
  late LocationBloc location;
  @override
  void initState() {
    location = BlocProvider.of<LocationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
        bloc: location,
        builder: (context, state) {
          if (state is LocationLoading) {
            return const CircularProgressIndicator();
          } else if (state is LocationDetailsLoaded) {
            return buildWeatherList(
              state.forecast.daily,
              state.forecast.hourly,
            );
          } else {
            return const Text('Unknown state');
          }
        });
  }

  Widget buildWeatherList(
    List<Forecast> hourlyForecast,
    List<Forecast> dailyForecast,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                bottom: 20,
              ),
              child: Text(
                AppLocalizations.of(context).todaysWeather,
                style: kContinueText,
              ),
            ),
            WeatherHorizontalList(
              forecastList: hourlyForecast,
              isHour: true,
            )
          ],
        ),
      ),
    );
  }
}

class WeatherHorizontalList extends StatelessWidget {
  final List<Forecast> forecastList;
  final bool isHour;

  const WeatherHorizontalList({
    Key? key,
    required this.forecastList,
    required this.isHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollDirection: Axis.horizontal,
      itemCount: forecastList.length,
      itemBuilder: (context, index) {
        final forecast = forecastList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: WeatherCard(
            forecast: forecast,
            isHour: isHour,
          ),
        );
      },
    );
  }
}
