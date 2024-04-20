import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../domain/models/forecast_model.dart';
import '../../../domain/services/date_service.dart';

class WeatherCard extends StatefulWidget {
  final Forecast forecast;
  final bool isHour;

  const WeatherCard({
    Key? key,
    required this.forecast,
    required this.isHour,
  }) : super(key: key);

  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  bool _showFront = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => setState(() {
        _showFront = !_showFront;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Container(
                  decoration:
                      BoxDecoration(gradient: getTemperatureGradient())),
              Positioned.fill(
                child: _buildWeatherSceneWidget(),
              ),
              if (_showFront)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ).animate().fade(),
                ),
              AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: _showFront ? 1 : 0,
                  child: _buildFront()),
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: 0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(getTime(false),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Colors.black)),
                      Text(getTime(true),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.black)),
                      Text(getTemperature(), // Display temperature
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .moveY(curve: Curves.easeIn)
            .fadeIn(duration: Duration(milliseconds: 320)),
      ),
    );
  }

  Widget _buildFront() {
    String formattedTime =
        DateTimeService.parseFromSeconds("${widget.forecast.date}");

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text('Temperature: ${widget.forecast.temperature}°C'),
          Text('Humidity: ${widget.forecast.humidity}%'),
          Text('Wind Speed: ${widget.forecast.windSpeed} m/s'),
          Text('Wind Direction: ${widget.forecast.windDirection}°'),
          Text('Wind Gusts: ${widget.forecast.windGusts} m/s'),
          Text('Pressure: ${widget.forecast.pressure} hPa'),
          Text('Precipitation: ${widget.forecast.precipitation} mm'),
          if (widget.isHour) ...[
            // Additional content specific for hourly forecast
          ],
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _buildWeatherSceneWidget();
  }

  Widget _buildWeatherSceneWidget() {
    WeatherScene scene;

    if (widget.forecast.temperature >= 0 &&
        widget.forecast.temperature <= 5 &&
        widget.forecast.windSpeed > 0) {
      scene = WeatherScene.rainyOvercast;
    } else if (widget.forecast.temperature >= 5 &&
        widget.forecast.temperature <= 10) {
      scene = WeatherScene.sunset;
    } else if (widget.forecast.temperature > 10 &&
        widget.forecast.temperature <= 20 &&
        widget.forecast.windSpeed > 0) {
      scene = WeatherScene.scorchingSun;
    } else if (widget.forecast.temperature > 20) {
      scene = WeatherScene.scorchingSun;
    } else if (widget.forecast.temperature < 0 &&
        widget.forecast.windSpeed > 0) {
      scene = WeatherScene.snowfall;
    } else if (widget.forecast.temperature < 0) {
      scene = WeatherScene.frosty;
    } else {
      scene = WeatherScene.rainyOvercast; // Default scene for other cases
    }

    return WeatherSceneWidget(weatherScene: scene);
  }

  void _showMoreInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).moreInfo),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMoreInfoRow(
                AppLocalizations.of(context).humidity,
                '${widget.forecast.humidity}%',
              ),
              _buildMoreInfoRow(
                AppLocalizations.of(context).windSpeed,
                '${widget.forecast.windSpeed} m/s',
              ),
              _buildMoreInfoRow(
                AppLocalizations.of(context).windDirection,
                '${widget.forecast.windDirection}°',
              ),
              _buildMoreInfoRow(
                AppLocalizations.of(context).windGusts,
                '${widget.forecast.windGusts} m/s',
              ),
              _buildMoreInfoRow(
                AppLocalizations.of(context).pressure,
                '${widget.forecast.pressure} hPa',
              ),
              _buildMoreInfoRow(
                AppLocalizations.of(context).precipitation,
                '${widget.forecast.precipitation} mm',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  RadialGradient getTemperatureGradient() {
    final double temperature = widget.forecast.temperature;

    if (temperature >= -10 && temperature < 2) {
      // Teplota od -10 do 2 °C
      return const RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [Color.fromARGB(255, 26, 32, 35), Color(0xff292e49)],
      );
    } else if (temperature >= 2 && temperature <= 10) {
      // Teplota od 2 do 10 °C
      return const RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [Color(0xffede574), Color(0xffe1f5c4)],
      );
    } else {
      // Teplota nad 10 °C
      return const RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [Color(0xffff512f), Color(0xfff09819)],
      );
    }
  }

  Widget _buildWeatherIcon(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (widget.forecast.character) {
      case 0:
        iconData = Icons.wb_sunny; // Slunečno
        iconColor = Colors.yellow;
        break;
      case 1:
        iconData = Icons.cloud; // Slabě zataženo
        iconColor = Colors.grey;
        break;
      case 2:
        iconData = Icons.cloud; // Zataženo
        iconColor = Colors.grey;
        break;
      case 3:
        iconData = Icons.cloud; // Silně zataženo
        iconColor = Colors.grey;
        break;
      case 4:
        iconData = Icons.wb_sunny; // Polojasno
        iconColor = Colors.yellow;
        break;
      case 5:
        iconData = Icons.wb_sunny; // Malé polojasno
        iconColor = Colors.yellow;
        break;
      case 6:
        iconData = Icons.cloud; // Mírně zataženo
        iconColor = Colors.grey;
        break;
      case 7:
        iconData = Icons.storm; // Bouřka
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.cloud; // Výchozí ikona pro neznámou hodnotu
        iconColor = Colors.grey;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 80,
    );
  }

  String getTime(bool isHour) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.forecast.date * 1000);
    String dayName = DateFormat('EEEE', 'cs_CZ').format(dateTime);
    if (isHour) {
      // Display date and time when expanded
      return '${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? 'AM' : 'PM'}';
    } else {
      // Display only the date when not expanded
      return ' ${dayName.toUpperCase()}, ${dateTime.day}.${dateTime.month}';
    }
  }

  String getTemperature() {
    return '${widget.forecast.temperature}°C';
  }
}
