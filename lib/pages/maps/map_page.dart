import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maps"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: content(),
    );
  }

  Widget content()
  {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(12.8437815, 80.151957),
        initialZoom: 17,
        interactionOptions: InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom)
      ),
      children: [
        openStreetMapTileLayer,
        CircleLayer(
          circles: [
          CircleMarker(point: const LatLng(12.8437815, 80.151957),
           radius: 50, useRadiusInMeter: true,
           color: Colors.red.withOpacity(0.65))]),
      ], 
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',);