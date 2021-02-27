import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'orders_view_model.dart';

final ordersViewModelProvider = ChangeNotifierProvider<OrdersViewModel>(
  (ref) => OrdersViewModel(),
);
