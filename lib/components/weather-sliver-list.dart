import 'package:flutter/material.dart';
import 'package:mobile/components/current-day.dart';
import 'package:mobile/components/current-weather-info.dart';
import 'package:mobile/components/daily-forecast.dart';
import 'package:mobile/components/hourly-forecast.dart';
import 'package:mobile/components/subtitles.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/day.dart';
import 'package:mobile/models/hour.dart';

class WeatherSliverList extends StatelessWidget {
  final Day today;
  final List<Day> dailyForecasts;
  final List<Hour> hourlyForecasts;
  final bool darkMode;
  const WeatherSliverList({
    required this.today,
    required this.dailyForecasts,
    required this.hourlyForecasts,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEEE, MMM dd').format(DateTime.now());

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(formattedDate),
              CurrentDay(today),
              Subtitles('Hourly forecast'),
              HourlyForecast(hourlyForecasts),
              Subtitles('Daily forecast'),
              DailyForecast(dailyForecasts),
              Subtitles('Current weather info'),
              CurrentWeatherInfo(today.weatherDetails, darkMode),
            ],
          ),
        ),
      ]),
    );
  }
}
