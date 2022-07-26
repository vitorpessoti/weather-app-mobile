import 'package:flutter/material.dart';
import 'package:mobile/components/current-weather-info-item.dart';
import 'package:mobile/models/weather-details.dart';

class CurrentWeatherInfo extends StatelessWidget {
  final List<WeatherDetails> item;
  final bool darkMode;
  const CurrentWeatherInfo(this.item, this.darkMode);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GridView.builder(
        itemCount: item.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (context, index) => CurrentWeatherInfoItem(
          details: item[index],
          darkMode: darkMode,
        ),
      ),
    );
  }
}
