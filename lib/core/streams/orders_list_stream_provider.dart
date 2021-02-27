import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_boy/core/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersListStreamProvider = StreamProvider.family<List<Order>, String>(
  (ref, status) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection('orders')
        .where("deliveryBoyMobile",isEqualTo: _auth.currentUser.phoneNumber.split("+91").last)
        .where("status", isEqualTo: status)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Order.fromFirestore(doc: e),
              )
              .toList(),
        );
  },
);
