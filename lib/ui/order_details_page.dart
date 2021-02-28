import 'package:delivery_boy/core/models/cartProduct.dart';
import 'package:delivery_boy/core/models/order.dart';
import 'package:delivery_boy/core/streams/order_stream_provider.dart';
import 'package:delivery_boy/core/view_model/orders_view_model/orders_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/two_text_row.dart';

class OrderDetailsPage extends ConsumerWidget {
  final String id;
  const OrderDetailsPage({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var orderStream = watch(orderStreamProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: orderStream.when(
        data: (order) {
          return ListView(
            padding: EdgeInsets.all(4),
            children: [
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Column(
                      children: order.products.map((e) {
                        var product = CartProduct.fromJson(e);
                        return ListTile(
                          title: Text(product.name),
                          leading: SizedBox(
                            height: 56,
                            width: 56,
                            child: Image.network(product.image),
                          ),
                          subtitle: Text(
                            product.qt.toString() +
                                " Items x ₹" +
                                product.price.toString(),
                          ),
                          trailing: Text(
                            "₹" + (product.qt * product.price).toString(),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Order Summary',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    TwoTextRow(
                        text1: "Items (6)",
                        text2: '₹' + order.price.toString()),
                    TwoTextRow(
                        text1: "Delivery",
                        text2: '₹' + order.delivery.toString()),
                    TwoTextRow(
                        text1: 'Service Tax',
                        text2: '₹' + order.tax.toString()),
                    TwoTextRow(
                        text1: "Wallet Amount",
                        text2: '₹' + order.walletAmount.toString()),
                    TwoTextRow(
                        text1: 'Total Price',
                        text2: '₹' + order.totalPrice.toString())
                  ],
                ),
              ),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Delivery Details',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    TwoTextRow(text1: "Status", text2: order.status),
                    order.status == "Out For Delivery"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              colorBrightness: Brightness.dark,
                              child: Text("SET AS DELIVERED"),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => PopWidget(order: order),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                    Divider(),
                    TwoTextRow(text1: "Delivery Date", text2: order.date),
                    TwoTextRow(text1: 'Delivery By', text2: order.deliveryBy),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Delivery Address'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: GoogleMap(
                          liteModeEnabled: true,
                          key: Key(order.customerAddress),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(order.geoPoint.latitude,
                                order.geoPoint.longitude),
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("1"),
                              position: LatLng(order.geoPoint.latitude,
                                  order.geoPoint.longitude),
                            ),
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(order.customerAddress),
                    ),
                  ],
                ),
              ),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Payment',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    TwoTextRow(text1: "Status", text2: order.paymentStatus),
                    TwoTextRow(
                        text1: "Payment Method", text2: order.paymentMethod),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => SizedBox(),
      ),
    );
  }
}

class PopWidget extends ConsumerWidget {
  final Order order;
  PopWidget({Key key, this.order}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var model = watch(ordersViewModelProvider);
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            order.paymentMethod == "Cash On Delivery"
                ? Row(
                    children: [
                      Checkbox(
                        value: model.given,
                        onChanged: model.setGiven,
                      ),
                      Flexible(
                          child: Text(
                              "Customer has given ₹${order.totalPrice} amount to me."))
                    ],
                  )
                : SizedBox(),
            TextFormField(
              validator: (value) =>
                  value != order.code ? "Incorrect Code" : null,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "Delivery Code",
              ),
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            if (order.paymentMethod == "Cash On Delivery" && !model.given) {
              Fluttertoast.showToast(
                  msg: "check customer has given this amount to you.");
              return;
            }
            if (_formKey.currentState.validate()) {
              model.setAsDelivered(order.id);
              Navigator.pop(context);
            }
          },
          child: Text("DELIVERED"),
          color: Theme.of(context).accentColor,
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );
  }
}

class WhiteCard extends StatelessWidget {
  final Widget child;
  WhiteCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: Padding(padding: const EdgeInsets.all(12.0), child: child),
      ),
    );
  }
}
