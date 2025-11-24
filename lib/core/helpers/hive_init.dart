import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox("userBox");
  Hive.registerAdapter(RestaurantModelAdapter());
  await Hive.openBox("restaurantBox");
}
