import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/pages/search-places-page.dart';
import 'package:mobile/pages/welcome-page.dart';
import 'package:mobile/providers/cities-provider.dart';
import 'package:mobile/providers/weather-provider.dart';
import 'package:mobile/utils/app-routes.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://b9b5381184d64539b389021e4eb8276a@o1334218.ingest.sentry.io/6600485';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(WeatherApp()),
  );

  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}

// void main() {
//   FlutterError.onError = (FlutterErrorDetails details) {
//     FlutterError.presentError(details);
//     if (kReleaseMode) exit(1);
//   };
//   runApp(WeatherApp());
// }

class WeatherApp extends StatelessWidget {
  WeatherApp({Key? key}) : super(key: key);

  final ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'PTSans',
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CitiesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: appTheme.copyWith(
          colorScheme: appTheme.colorScheme.copyWith(
            primary: Colors.deepPurple,
            secondary: Colors.teal,
          ),
          canvasColor: const Color.fromRGBO(255, 254, 229, 1),
          textTheme: appTheme.textTheme.copyWith(
            headline1: const TextStyle(
              fontSize: 24,
              fontFamily: 'PTSans',
            ),
            subtitle1: const TextStyle(
              fontSize: 18,
              fontFamily: 'PTSans',
              color: Colors.black,
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        routes: {
          AppRoutes.WELCOME_PAGE: (ctx) => WelcomePage(),
          AppRoutes.SEARCH_PAGE: (ctx) => SearchPlacesPage(),
        },
      ),
    );
  }
}
