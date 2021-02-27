import 'package:delivery_boy/core/models/order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends ChangeNotifier {
  GoogleMapController controller;

  void setController(GoogleMapController value) {
    controller = value;
  }

  Order order;
  void setOrder(Order value) {
    order = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  CameraPosition _position = CameraPosition(
    target: LatLng(19.084383799507364, 72.88087688252803),
    zoom: 13,
  );
  CameraPosition get position => _position;

  void toggleMapType() {
    _mapType == MapType.normal
        ? _mapType = MapType.hybrid
        : _mapType = MapType.normal;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    _position = position;
  }
}
