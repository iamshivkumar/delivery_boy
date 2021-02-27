import 'package:delivery_boy/core/models/order.dart';
import 'package:delivery_boy/core/services/date.dart';
import 'package:flutter/material.dart';
import '../order_details_page.dart';
import 'two_text_row.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                key: Key(order.id),
                id: order.id,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TwoTextRow(
                  text1: "Delivery Date",
                  text2: order.date,
                ),
                TwoTextRow(
                  text1: "Delivery By",
                  text2: order.deliveryBy,
                ),
                Divider(
                  height: 0.5,
                ),
                TwoTextRow(
                  text1: "Ordered at",
                  text2: Date().datetime(order.timestamp),
                ),
                TwoTextRow(
                  text1: "Items",
                  text2: "${order.items} Items purchased",
                ),
                TwoTextRow(
                  text1: "Price",
                  text2: "₹" + order.totalPrice.toString(),
                ),
                TwoTextRow(
                  text1: "Payment (${order.paymentMethod})",
                  text2: order.paymentStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///[SmallOrderCard] used in [Orders_Map_View] widget
class SmallOrderCard extends StatelessWidget {
  final Order order;
  const SmallOrderCard({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                key: Key(order.id),
                id: order.id,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TwoTextRow(
                  text1: "Ordered at",
                  text2: Date().datetime(order.timestamp),
                ),
                TwoTextRow(
                  text1: "Items",
                  text2: "${order.items} Items purchased",
                ),
                TwoTextRow(
                  text1: "Price",
                  text2: "₹" + order.totalPrice.toString(),
                ),
                TwoTextRow(
                  text1: "Payment (${order.paymentMethod})",
                  text2: order.paymentStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
