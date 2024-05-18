import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:maplibre_demo/controllers/fetchdata_controller.dart';
import 'package:maplibre_demo/models/prediction.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MaplibreMapController mapController;
  TextEditingController _searchController = TextEditingController();

  Future<List<Predection>> placeAutoComplete(String query) async {
    return fakePredection
        .where((element) =>
            element.name.toUpperCase().contains(query.toUpperCase()))
        .toList();
  }

  void _addMarker(LatLng point) {
    mapController.addSymbol(SymbolOptions(
      geometry: point,
      iconImage: "custom-marker",
      iconSize: 0.1,
    ));
  }

  Future<void> _loadMarkerImage() async {
    final ByteData bytes = await rootBundle.load("assets/images/marker.png");
    final Uint8List list = bytes.buffer.asUint8List();
    mapController.addImage("custom-marker", list);
  }

  void _onMapCreated(MaplibreMapController controller) {
    mapController = controller;
    _loadMarkerImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('MapLibre GL Demo'),
      ),
      body: Stack(
        children: [
          MaplibreMap(
            styleString:
                'https://maps.visafe.com.vn/api/v1/styles/colorful/style.json',
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.7885905, 106.6669843),
              zoom: 16.0,
            ),
            onMapClick: (point, coordinates) {
              setState(() {
                _addMarker(coordinates);
              });
            },
          ),
          Positioned(
              top: 5,
              left: 10,
              right: 50,
              child: Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TypeAheadField<Predection>(
                        controller: _searchController,
                        onSelected: (value) {
                          _searchController.text = value.name;
                          _addMarker(value.latLng);
                          mapController.animateCamera(
                              CameraUpdate.newLatLngZoom(value.latLng, 16.0),
                              duration: const Duration(seconds: 5));
                        },
                        builder: (context, contronller, focusNode) {
                          return TextField(
                            controller: contronller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Search location',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  letterSpacing: 1.2),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              placeAutoComplete(value);
                            },
                          );
                        },
                        suggestionsCallback: (pattern) async {
                          print(pattern);
                          return await placeAutoComplete(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 3),
                                Expanded(
                                    child: Text(
                                  suggestion.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ))
                              ],
                            ),
                          );
                        },
                      )),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          placeAutoComplete(_searchController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
