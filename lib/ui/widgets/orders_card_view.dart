import 'package:delivery_boy/core/streams/orders_list_stream_provider.dart';
import 'package:delivery_boy/core/view_model/orders_view_model/orders_view_model_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'order_card.dart';
class OrdersPageView extends ConsumerWidget {
  final String status;
  OrdersPageView({this.status});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var ordersListStream = watch(ordersListStreamProvider(status));
    var model = context.read(ordersViewModelProvider);

    return ordersListStream.when(
      data: (ordersList) => ListView(
        padding: EdgeInsets.all(4),
        children: <Widget>[
              SizedBox(
                height: 128,
              )
            ] +
            ordersList
                .where((element) => model.deliveryDay != null
                    ? element.date == model.deliveryDay
                    : true)
                .where((element) => model.deliveryBy != null
                    ? element.deliveryBy == model.deliveryBy
                    : true)
                .map(
                  (e) => OrderCard(
                    order: e,
                    key: Key(e.id),
                  ),
                )
                .toList(),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Text(
        error.toString(),
      ),
    );
  }
}
