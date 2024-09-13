// import 'dart:convert';
// import 'package:sentry/sentry.dart';
import 'package:flutter/material.dart';
import '../components/search-item.dart';
import '../providers/cities-provider.dart';
import '../utils/app-routes.dart';
import 'package:provider/provider.dart';

class SearchPlacesPage extends StatefulWidget {
  const SearchPlacesPage({Key? key}) : super(key: key);

  @override
  State<SearchPlacesPage> createState() => _SearchPlacesPageState();
}

class _SearchPlacesPageState extends State<SearchPlacesPage> {
  final _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<CitiesProvider>(
      context,
      listen: false,
    ).clearCities();
  }

  @override
  Widget build(BuildContext context) {
    final CitiesProvider citiesProvider = Provider.of(context);

    void _searchPlaces(namePrefix) async {
      setState(() {
        _isLoading = true;
      });

      try {
        Map searchResponse =
            await citiesProvider.getCitiesByNamePrefix(namePrefix);

        if (searchResponse['data'].length > 0) {
          setState(() {
            _isLoading = false;
          });
        } else {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  'There was an error during the search. Please contact the system admin. Error code: 0x001.'),
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
      } catch (error /*, stackTrace*/) {
        // await Sentry.captureException(error, stackTrace: stackTrace);

        // Map<String, dynamic> errorObject = jsonDecode(jsonEncode(error));

        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'There was an error during the search. Please contact the system admin. Error code: 0x002.'),
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

    // void _searchPlaces(namePrefix) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   citiesProvider
    //       .getCitiesByNamePrefix(namePrefix)
    //       .then((value) => {
    //             setState(() {
    //               _isLoading = false;
    //             })
    //           })
    //       .catchError((error) => {print('catchError: ${error}')});
    // }

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          showCursor: true,
          decoration: InputDecoration.collapsed(
            hintText: 'Enter the city name...',
            focusColor: Colors.white,
          ),
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          controller: _searchController,
        ),
        actions: [
          IconButton(
            onPressed: () => _searchPlaces(_searchController.value.text),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ListView.builder(
                itemCount: citiesProvider.items.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) =>
                    SearchItem(citiesProvider.items[index]),
              ),
            ),
    );
  }
}
