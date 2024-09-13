import 'package:flutter/material.dart';
import './current-day.dart';
import './current-weather-info.dart';
import './daily-forecast.dart';
import './hourly-forecast.dart';
import './subtitles.dart';
import 'package:intl/intl.dart';
import '../models/day.dart';
import '../models/hour.dart';

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
