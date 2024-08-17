import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map_app/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../map_styles/map_style1.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? mapController;
  late String mapStyle;
  Set<Marker> markers = {};
  late Set<Polyline> polylines;
  late Set<Polygon> polygones;
  late Location location;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = CameraPosition(
      target: LatLng(36.28110459671162, 7.948813726016149),
      zoom: 15,
    );
    DefaultAssetBundle.of(context)
        .loadString('assets/google_map_styles/main_style.json')
        .then((value) {
      mapStyle = value;
    });

    //initMarkers();
    initPolylines();
    initPolygones();
    location = Location();
    requestLocationService();
    requestLocationPermission();
    location.onLocationChanged.listen((loc) {
      var latLng = LatLng(loc.latitude!, loc.longitude!);

      var cameraPosition = CameraPosition(
        target: latLng,
        zoom: 15,
      );
      setState(() {
        markers.add(
          Marker(markerId: MarkerId('Me'), position: latLng),
        );
      });
      mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void initMarkers() {
    markers = places.map<Marker>((place) {
      return Marker(
          markerId: MarkerId(
            place.id.toString(),
          ),
          infoWindow:
              InfoWindow(title: place.name, snippet: 'Plcae${place.id}'),
          position: place.latLng);
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            polylines: polylines,
            polygons: polygones,
            circles: {
              Circle(
                  circleId: CircleId('1'),
                  center: LatLng(36.2811769768327, 7.942980209277072),
                  radius: 120,
                  fillColor: Colors.blue.withOpacity(0.5),
                  strokeWidth: 1,
                  strokeColor: Colors.blue)
            },
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: initialCameraPosition,
            zoomControlsEnabled: false,
            style: mapOption1,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            top: MediaQuery.of(context).size.height - 80,
            child: ElevatedButton(
              onPressed: () {
                updateCamera();
              },
              child: const Text('Change Position'),
            ),
          ),
        ],
      ),
    );
  }

  void updateCamera() async {
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(36.2811769768327, 7.942980209277072), zoom: 15),
      ),
    );
  }

  void loadMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/google_map_styles/main_style.json');
  }

  void initPolylines() {
    polylines = {
      Polyline(
          polylineId: PolylineId("1"),
          color: Colors.red,
          width: 10,
          points: [
            LatLng(36.27980226253747, 7.948816799124815),
            LatLng(36.28133345047409, 7.952571492175562),
            LatLng(36.28460937959412, 7.954515097990063),
            LatLng(36.28382601774846, 7.95906490251038),
            LatLng(36.2854639471853, 7.962952114139386),
          ]),
    };
  }

  void initPolygones() {
    polygones = {
      Polygon(
          polygonId: PolygonId("1"),
          fillColor: Colors.amber.withOpacity(0.8),
          points: [
            LatLng(36.274496285926595, 7.9453713160900135),
            LatLng(36.291730490251645, 7.94917018200018),
            LatLng(36.294507547259435, 7.966088387158245),
          ],
          holes: [
            [
              LatLng(36.28446695075248, 7.9492143548596),
              LatLng(36.2870094813903, 7.951525655859401),
              LatLng(36.287632142978, 7.946933713845139),
            ],
          ]),
    };
  }

  //1 Check Loaction Service if enabled

  requestLocationService() async {
    bool isServiceEnabled = false;
    isServiceEnabled = await location.serviceEnabled();
    if (isServiceEnabled) {
      log("enabled");
    } else {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        log("NO SERVICE");
      }
    }
  }

  requestLocationPermission() async {
    late PermissionStatus isPermissionGranted;
    isPermissionGranted = await location.hasPermission();
    log(isPermissionGranted.toString());
    if (isPermissionGranted == PermissionStatus.granted) {
      log("granted");
    } else {
      isPermissionGranted = await location.requestPermission();
      log(isPermissionGranted.toString());
    }
  }
}
