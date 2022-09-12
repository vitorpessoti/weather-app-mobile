import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get openWeatherKey => _get('OPENWEATHER_KEY');
  static String get geodbHost => _get('GEODB_HOST');
  static String get geodbKey => _get('GEODB_KEY');

  static String _get(String name) => dotenv.env[name] ?? '';
}
