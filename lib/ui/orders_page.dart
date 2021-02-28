import 'package:delivery_boy/core/services/date.dart';
import 'package:delivery_boy/core/view_model/orders_view_model/orders_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/orders_card_view.dart';
import 'widgets/orders_map_view.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final List<String> tabTexts = [
    "Out For Delivery",
    "Delivered",
  ];

  final List<String> deliveryByRanges = [
    "9:00 AM - 10:30 AM",
    '10:00 AM - 11:00 AM',
    '12:00 PM - 1:00 PM',
    '2:00 PM - 4:00 PM'
  ];
  TabController _controller;
  final Date _date = Date();

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var model = watch(ordersViewModelProvider);
        return Scaffold(
          appBar: AppBar(
            actions: [
              Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 32,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: Icon(
                        Icons.location_pin,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Switch(
                value: model.mapMode,
                onChanged: model.setMapMode,
              ),
            ],
            title: Text('My Deliveries'),
            bottom: TabBar(
              onTap: (value) {
                if (model.mapMode) {
                  setState(() {});
                }
              },
              controller: _controller,
              isScrollable: true,
              tabs: tabTexts
                  .map(
                    (e) => Tab(
                      text: e,
                    ),
                  )
                  .toList(),
            ),
          ),
          body: Stack(
            children: [
              model.mapMode
                  ? OrdersMapView(
                      status: tabTexts[_controller.index],
                    )
                  : TabBarView(
                      controller: _controller,
                      children: tabTexts
                          .map(
                            (e) => OrdersPageView(
                              status: e,
                            ),
                          )
                          .toList(),
                    ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                "Filter through delivery day and delivery by:",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(0),
                                      onSelected: (value) =>
                                          model.setDeliveryDay(value
                                              ? _date.activeDate(0)
                                              : null),
                                      label: Text("Today"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(1),
                                      onSelected: (value) =>
                                          model.setDeliveryDay(value
                                              ? _date.activeDate(1)
                                              : null),
                                      label: Text("Tommorow"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(2),
                                      onSelected: (value) =>
                                          model.setDeliveryDay(value
                                              ? _date.activeDate(2)
                                              : null),
                                      label: Text(_date.activeDay(2)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: deliveryByRanges
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 0, 4, 4),
                                          child: ChoiceChip(
                                            selected: model.deliveryBy == e,
                                            onSelected: (value) =>
                                                model.setDeliveryBy(
                                                    value ? e : null),
                                            label: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
