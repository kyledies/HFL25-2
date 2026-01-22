import 'dart:async'; 

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:herodex3000/shared/widgets/loading_widget.dart';
import 'package:latlong2/latlong.dart';

class SimpleMapView extends StatefulWidget {
  const SimpleMapView({super.key});

  @override
  State<SimpleMapView> createState() => _SimpleMapViewState();
}

class _SimpleMapViewState extends State<SimpleMapView> {
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream; //för live positionering

  @override
  void initState() {
    super.initState();
    _startLiveLocation();
  }

  // ⭐ NY METOD
  Future<void> _startLiveLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, 
      ),
    ).listen((position) {
      setState(() {
        _currentPosition = LatLng(
          position.latitude,
          position.longitude,
        );
      });
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: AppLoader(label: 'Laddar Kartan…'),
      );
    }

    return FlutterMap(
      options: MapOptions(initialCenter: _currentPosition!, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.herodex3000',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition!,
              width: 40,
              height: 40,

              child: Icon(
                Icons.bolt,
                size: 48,
                color: Theme.of(context).colorScheme.onPrimary,
                shadows: [
                  Shadow(color: Color(0xFFFF1744), blurRadius: 30),
                  Shadow(color: Color(0xFFFF1744), blurRadius: 10),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
