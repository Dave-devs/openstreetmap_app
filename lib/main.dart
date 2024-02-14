import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenStreetMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapViewPage(),
    );
  }
}

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final Uri _url = Uri.parse('https://www.openstreetmap.org');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final LatLng latlng = const LatLng(6.465422, 3.406448);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            // onTap: (p, l) async {https://tile.openstreetmap.org/{z}/{x}/{y}.png
            //   try {
            //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            //   } catch (e) {
            //     debugPrint('Internal error occureed!');
            //   }
            // },
            initialCenter: LatLng(6.465422, 3.406448),
            initialZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.openstreetmap_app',
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap',
                  textStyle: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w200,
                  ),
                  onTap: _launchUrl,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: size.width,
                  height: size.height,
                  point: latlng,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),
              ],
            )
          ],
        ),
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 34.0),
        //   child: Column(
        //     children: [
        //       Card(
        //         child: TextField(
        //           decoration: InputDecoration(
        //             prefixIcon: Icon(Icons.location_city_outlined),
        //             hintText: 'Search for location',
        //             contentPadding: EdgeInsets.all(16.0),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const Card(
        //   child: Text(
        //     'Address',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
      ],
    );
  }
}
