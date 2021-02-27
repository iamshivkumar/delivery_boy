import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'map_view_model.dart';


final mapViewModelProvider = ChangeNotifierProvider<MapViewModel>(
  (ref) => MapViewModel(),
);
