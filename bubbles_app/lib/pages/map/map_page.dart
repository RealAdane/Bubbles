import 'dart:math';

import 'package:bubbles_app/models/bubble.dart';
import 'package:bubbles_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Timer _timer;
  final LatLng _currentLatLng = LatLng(31.808700, 34.654860);
  Color _markerColor = Colors.red;

  DatabaseService _db = GetIt.instance.get<DatabaseService>();

  List<Map<String, dynamic>> _bubblesMarks = [];

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _fetchBubbles();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: _buildMap(),
    );
  }

  Widget _buildMap() {
    var x = _currentLatLng.latitude;
    var y = _currentLatLng.longitude;
    return FlutterMap(
      options: MapOptions(
        zoom: 20,
        center: LatLng(x, y),
        bounds: LatLngBounds(LatLng(x, y), LatLng(x, y)),
        maxZoom: 18,
      ),
      children: [
        _buildTileLayer(),
        _buildMarkerLayer(),
      ],
    );
  }

  TileLayer _buildTileLayer() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    );
  }

  MarkerLayer _buildMarkerLayer() {
    List<Marker> markers = [];

    // Add bubble markers
    for (var bubble in _bubblesMarks) {
      // double latitude = bubble['location'].latitude;
      // double longitude = bubble['location'].longitude;
      final bubbleColor = [
        Colors.green,
        Colors.lightBlue,
        Colors.purple,
        Colors.red,
        Colors.blue,
      ][bubble['keyType']];
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: _currentLatLng,
          builder: (ctx) {
            return Column(
              children: [
                Icon(
                  Icons.location_on,
                  color: bubbleColor,
                ),
                Text(
                  bubble['name'],
                  style: TextStyle(
                    color: bubbleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // Add current location marker
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: _currentLatLng,
        builder: (ctx) => const Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    );

    return MarkerLayer(markers: markers);
  }

  Future<void> _fetchBubbles() async {
    List<Map<String, dynamic>> bubbles = await _db.getBubblesFormarks();
    setState(() {
      _bubblesMarks = bubbles;
    });
  }
}