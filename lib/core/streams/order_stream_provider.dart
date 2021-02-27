import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_boy/core/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderStreamProvider = StreamProvider.family<Order, String>(
  (ref, id) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection('orders').doc(id).snapshots().map(
          (e) => Order.fromFirestore(doc: e),
        );
  },
);
