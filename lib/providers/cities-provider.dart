import 'dart:convert';
import 'package:flutter/material.dart';
import '../classes/config.dart';
import '../models/city.dart';
import 'package:http/http.dart' as http;
// import 'package:mobile/utils/defs.dart';

class CitiesProvider with ChangeNotifier {
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
  // final String _baseUrl = '${Defs.API_URL}';

  Future<Map> getCitiesByNamePrefix(String namePrefix) async {
    _items.clear();
    print('---------> getCitiesByNamePrefix');
    print(Config.geodbHost);
    print(Config.geodbKey);
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-RapidAPI-Host': Config.geodbHost,
      'X-RapidAPI-Key': Config.geodbKey
    };

    final response = await http.get(
      Uri.parse(
          'https://${Config.geodbHost}/v1/geo/cities?namePrefix=${namePrefix}&namePrefixDefaultLangResults=false&sort=-population&types=CITY'),
      headers: requestHeaders,
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);

    // if (responseData['status']) {
    responseData['data'].forEach((element) {
      _items.add(
        City(
          id: element['id'],
          type: element['type'],
          city: element['city'],
          name: element['name'],
          country: element['country'],
          countryCode: element['countryCode'],
          region: element['region'],
          regionCode: element['regionCode'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          population: element['population'],
        ),
      );
    });
    // } else {
    //   throw responseData;
    // }

    notifyListeners();
    return responseData;
  }

  Future<Map> getCitiesByLatLong(double latitude, double longitude) async {
    print('---------> getCitiesByLatLong');
    print(Config.geodbHost);
    print(Config.geodbKey);
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-RapidAPI-Host': Config.geodbHost,
      'X-RapidAPI-Key': Config.geodbKey
    };

    final response = await http.get(
      Uri.parse(
          'https://${Config.geodbHost}/v1/geo/cities?location=${latitude}${longitude}&limit=1'),
      headers: requestHeaders,
    );

    Map responseData = jsonDecode(response.body);

    responseData['data'].forEach((element) {
      _items.add(
        City(
          id: element['id'],
          type: element['type'],
          city: element['city'],
          name: element['name'],
          country: element['country'],
          countryCode: element['countryCode'],
          region: element['region'],
          regionCode: element['regionCode'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          population: element['population'],
        ),
      );
    });

    notifyListeners();
    return responseData;
  }

  void clearCities() {
    _items.clear();
  }
}
