import 'package:maplibre_gl/mapbox_gl.dart';

class Predection {
  final String name;
  final LatLng latLng;

  Predection({required this.name, required this.latLng});
}

List<Predection> fakePredection = [
  Predection(name: "HCMC", latLng: LatLng(10.762622, 106.660172)),
  Predection(name: "Hue", latLng: LatLng(16.464569, 107.600966)),
  Predection(name: "Da Lat", latLng: LatLng(11.946676, 108.441631)),
  Predection(name: "Quang Ngai", latLng: LatLng(15.120923, 108.789143)),
  Predection(name: "Nha Trang", latLng: LatLng(12.250320, 109.191480)),
  Predection(name: "Hoi An", latLng: LatLng(15.879367, 108.297017)),
  Predection(name: "Da Nang", latLng: LatLng(16.067192, 108.220917)),
  Predection(name: "Hai Phong", latLng: LatLng(20.990186, 106.330861)),
];
