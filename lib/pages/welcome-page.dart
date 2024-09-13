// import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import './home-page.dart';
import '../providers/cities-provider.dart';
import '../utils/app-routes.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  _getCurrentLocation() async {
    final CitiesProvider citiesProvider = Provider.of(context, listen: false);
    try {
      final locData = await Location().getLocation();
      print('----------- locData -----------------');
      print(locData);

      Map currentCityResponse = await citiesProvider.getCitiesByLatLong(
        // locData.latitude!,
        // locData.longitude!,
        -21.1320832,
        -47.9789056
      );

      if (currentCityResponse['data'].length > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(city: citiesProvider.items.first),
          ),
        );
      } else {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'There was an error getting your current location. Please contact the system admin. Error code: 0x004.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          ),
        );
      }
    } catch (error, stackTrace) {
      await Sentry.captureException(error, stackTrace: stackTrace);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'There was an error getting your current location. Please contact the system admin. Error code: 0x005.'),
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
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 80),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
    // return FutureBuilder(
    //   future: _getCurrentLocation(),
    //   builder: (context, snapshot) {
    //     return Scaffold(
    //       backgroundColor: Colors.teal,
    //       body: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Container(
    //             padding: EdgeInsets.only(top: 80),
    //             child: CircularProgressIndicator(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
