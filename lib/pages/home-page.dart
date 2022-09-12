import 'package:flutter/material.dart';
import 'package:mobile/components/weather-sliver-bar.dart';
import 'package:mobile/components/weather-sliver-list.dart';
import 'package:mobile/models/city.dart';
import 'package:mobile/providers/weather-provider.dart';
import 'package:mobile/utils/app-routes.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  final City city;
  const HomePage({required this.city});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });

    _loadForecast();
  }

  _loadForecast() async {
    final WeatherProvider weatherProvider = Provider.of(context, listen: false);

    try {
      await weatherProvider.getForecast(
        widget.city.latitude,
        widget.city.longitude,
      );

      // if (forecastResponse['status']) {
      _isLoading = false;
      // } else {
      //   await showDialog<void>(
      //     context: context,
      //     builder: (ctx) => AlertDialog(
      //       title: Text(forecastResponse['message']),
      //       content: Text(forecastResponse['item'].toString()),
      //       actions: [
      //         TextButton(
      //           onPressed: () =>
      //               Navigator.of(context).pushNamed(AppRoutes.SEARCH_PAGE),
      //           child: Text('OK'),
      //         )
      //       ],
      //     ),
      //   );
      // }
    } catch (error, stackTrace) {
      await Sentry.captureException(error, stackTrace: stackTrace);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'There was an error fetching the forecast. Please contact the system admin. Error code: 0x003.'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.SEARCH_PAGE),
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final WeatherProvider weatherProvider = Provider.of(context);
    final currentTime = weatherProvider.today?.currentTime ?? 0;
    final sunset = weatherProvider.today?.sunset ?? 0;
    final bool darkMode = (currentTime > sunset);
    // final bool darkMode = true;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor:
                darkMode ? Colors.grey.shade900 : Colors.blue.shade400,
            body: CustomScrollView(
              slivers: [
                WeatherSliverBar(
                  city: widget.city,
                  day: weatherProvider.today!,
                ),
                WeatherSliverList(
                  today: weatherProvider.today!,
                  dailyForecasts: weatherProvider.getDailyForecast,
                  hourlyForecasts: weatherProvider.getHourlyForecast,
                  darkMode: darkMode,
                ),
              ],
            ),
          );
  }
}
