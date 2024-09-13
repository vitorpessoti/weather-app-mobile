import 'package:flutter/material.dart';
import '../models/weather-details.dart';

class CurrentWeatherInfoItem extends StatelessWidget {
  final WeatherDetails details;
  final bool darkMode;
  const CurrentWeatherInfoItem({
    required this.details,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: darkMode ? Colors.grey.shade900 : Colors.blue.shade400,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/in_app_icons/${details.icon}.png',
              // fit: BoxFit.contain,
              // height: 25,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(details.title),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('${details.value} ${details.unit}'),
            )
          ],
        ),
      ),
    );
  }
}
