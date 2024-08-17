import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id, required this.name, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'Méga Pizza',
    latLng: const LatLng(36.285364404141355, 7.952700534871884),
  ),
  PlaceModel(
    id: 2,
    name: 'مستشفي ابن رشد',
    latLng: const LatLng(36.26334821260119, 7.951281313213951),
  ),
];
