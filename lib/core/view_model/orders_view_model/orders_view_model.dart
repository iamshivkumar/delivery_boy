import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrdersViewModel extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String deliveryDay;
  String deliveryBy;

  void setDeliveryDay(String value) {
    deliveryDay = value;
    notifyListeners();
  }

  void setDeliveryBy(String value) {
    deliveryBy = value;
    notifyListeners();
  }







  bool mapMode = false;
  void setMapMode(bool value) {
    mapMode = value;
    notifyListeners();
  }
}
