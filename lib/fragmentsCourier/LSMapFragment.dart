import 'dart:ui'; // Import pour ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:laundry/model/APIKey.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/LSColors.dart';
import 'package:laundry/components/LSNavBarCourier.dart';
import 'package:geolocator/geolocator.dart'; // Import for location services

class LSMapFragment extends StatefulWidget {
  static String tag = '/LSMapFragment';

  @override
  LSMapFragmentState createState() => LSMapFragmentState();
}

class LSMapFragmentState extends State<LSMapFragment> {
  int _selectedIndex = 1;
  late LatLng myPoint;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    myPoint = defaultPoint;
    init();
    _getCurrentLocation();
  }

  final LatLng defaultPoint = LatLng(-8.923303951223144, 13.182696707942991);

  List<LatLng> points = [];
  List<Marker> markers = [];

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        myPoint = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });

      // Move map to current location
      mapController.move(myPoint, 16.5);
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCoordinates(LatLng lat1, LatLng lat2) async {
    setState(() {
      isLoading = true;
    });

    try {
      final OpenRouteService client = OpenRouteService(
        apiKey: APIKey.findApiKeyByName('ORS')!.api_key,
      );

      final List<ORSCoordinate> routeCoordinates =
      await client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(
            latitude: lat1.latitude, longitude: lat1.longitude),
        endCoordinate: ORSCoordinate(
            latitude: lat2.latitude, longitude: lat2.longitude),
      );

      final List<LatLng> routePoints = routeCoordinates
          .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
          .toList();

      setState(() {
        points = routePoints;
        isLoading = false;
      });
    } catch (e) {
      // Gestion des erreurs
      setState(() {
        isLoading = false;
      });
      print('Erreur : $e');
    }
  }

  final MapController mapController = MapController();

  void _handleTap(LatLng latLng) {
    setState(() {
      if (markers.length < 2) {
        markers.add(
          Marker(
            point: latLng,
            width: 80,
            height: 80,
            child: Draggable(
              feedback: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.location_on),
                color: Colors.black,
                iconSize: 45,
              ),
              onDragEnd: (details) {
                setState(() {
                  print(
                      "Latitude : ${latLng.latitude}, Longitude : ${latLng.longitude}");
                });
              },
              child: const Icon(Icons.location_on),
            ),
          ),
        );
      }

      if (markers.length == 1) {
        double zoomLevel = 16.5;
        mapController.move(latLng, zoomLevel);
      }

      if (markers.length == 2) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            isLoading = true;
          });
          getCoordinates(markers[0].point, markers[1].point);

          LatLngBounds bounds = LatLngBounds.fromPoints(
              markers.map((marker) => marker.point).toList());
        });
      }
    });
  }

  Future<void> init() async {
    setStatusBarColor(context.cardColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn
          ? context.scaffoldBackgroundColor
          : LSColorSecondary,
      appBar: appBarWidget('Carte', center: true, showBack: false, color: context.cardColor,),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onTap: (tapPosition, latLng) => _handleTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: markers,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    color: Colors.black,
                    strokeWidth: 5,
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20.0,
            left: MediaQuery.of(context).size.width / 2 - 110,
            child: Align(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if (markers.isEmpty) {
                      print('Marquer des points sur la carte');
                    } else {
                      markers.clear();
                      points.clear();
                    }
                  });
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      markers.isEmpty
                          ? "Sélectionner deux points d'itinéraire"
                          : "Effacer l'itinéraire",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LSNavBarCourier(selectedIndex: _selectedIndex),
    );
  }
}
