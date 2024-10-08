import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../models/day.dart';
import '../models/hour.dart';
import '../models/weather-details.dart';
// import '../utils/defs.dart';
import '../classes/config.dart';

class WeatherProvider with ChangeNotifier {
  int? id;
  String? type;
  String? city;
  String? name;
  String? country;
  String? countryCode;
  String? region;
  String? regionCode;
  String? latitude;
  String? longitude;
  String? population;
  List<City> _items = [];
  List<City> get items => [..._items];
  Day? today;
  List<Day> _dailyForecast = [];
  List<Day> get getDailyForecast => [..._dailyForecast];
  List<Hour> _hourlyForecast = [];
  List<Hour> get getHourlyForecast => [..._hourlyForecast];
  List<String> _weekDays = [
    '',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  // final String _baseUrl = '${Defs.API_URL}';

  Future<Map> getForecast(double latitude, double longitude) async {
    _items.clear();
    _dailyForecast.clear();
    _hourlyForecast.clear();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final API_URL_ONECALL =
        'https://api.openweathermap.org/data/3.0/onecall?lat=${latitude}&lon=${longitude}&exclude=alerts,minutely&units=metric&appid=${Config.openWeatherKey}';

    final response = await http.get(
      Uri.parse(API_URL_ONECALL),
      headers: requestHeaders,
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);

    // if (responseData['status']) {
    today = new Day(
      month: 6,
      day: 2,
      weekDay: 'Thursday',
      icon: responseData['current']['weather'][0]['icon'],
      weather: responseData['current']['weather'][0]['main'],
      currentTemp: responseData['current']['temp'].toInt(),
      tempMax: responseData['daily'][0]['temp']['max'].toInt(),
      tempMin: responseData['daily'][0]['temp']['min'].toInt(),
      currentTime: responseData['current']['dt'],
      sunrise: responseData['current']['sunrise'],
      sunset: responseData['current']['sunset'],
      weatherDetails: [
        WeatherDetails(
            title: 'Feels like',
            icon: 'feels-like',
            value: responseData['current']['feels_like'].toStringAsFixed(0),
            unit: 'ºC'),
        WeatherDetails(
            title: 'Precipitation',
            icon: 'precipitation',
            value: '0.3',
            unit: 'mm'),
        WeatherDetails(
            title: 'Wind',
            icon: 'wind',
            value: responseData['current']['wind_speed'].toString(),
            unit: 'km/h'),
        WeatherDetails(
            title: 'Pressure',
            icon: 'pressure',
            value: responseData['current']['pressure'].toString(),
            unit: 'hPa'),
        WeatherDetails(
            title: 'Humidity',
            icon: 'humidity',
            value: responseData['current']['humidity'].toString(),
            unit: '%'),
        WeatherDetails(
            title: 'Dew point',
            icon: 'dew-point',
            value: responseData['current']['dew_point'].toStringAsFixed(0),
            unit: 'ºC'),
        WeatherDetails(
            title: 'UV index',
            icon: 'sun',
            value: responseData['current']['uvi'].toStringAsFixed(0),
            unit: '/10'),
      ],
    );

    responseData['daily'].forEach((element) {
      dynamic datetime = DateTime.fromMillisecondsSinceEpoch(
        element['dt'] * 1000,
        isUtc: false,
      );

      _dailyForecast.add(Day(
        month: datetime.month,
        day: datetime.day,
        weekDay: _weekDays[datetime.weekday],
        icon: element['weather'][0]['icon'],
        weather: element['weather'][0]['main'],
        currentTemp: element['temp']['day'].toInt(),
        tempMax: element['temp']['max'].toInt(),
        tempMin: element['temp']['min'].toInt(),
        currentTime: element['dt'],
        sunrise: element['sunrise'],
        sunset: element['sunset'],
        weatherDetails: [],
      ));
    });

    responseData['hourly'].forEach((element) {
      dynamic datetime = DateTime.fromMillisecondsSinceEpoch(
        element['dt'] * 1000,
        isUtc: false,
      );

      _hourlyForecast.add(Hour(
        month: datetime.month,
        day: datetime.day,
        hour: DateFormat('hh a').format(datetime),
        icon: element['weather'][0]['icon'],
        temp: element['temp'].toInt(),
        humidity: element['humidity'],
        windSpeed: element['wind_speed'].toInt(),
      ));
    });
    // } else {
    //   throw responseData;
    // }

    notifyListeners();
    return responseData;
  }
}
