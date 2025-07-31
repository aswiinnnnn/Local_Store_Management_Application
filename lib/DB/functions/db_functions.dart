import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';

ValueNotifier<List<OrderModel>> ordersListNotifier = ValueNotifier([]);
ValueNotifier<List<IncomeModel>> incomeListNotifier = ValueNotifier([]);

// Order Functions
Future<void> addOrder(OrderModel newOrder) async {
  final ordersDB = Hive.isBoxOpen('orders_db')
      ? Hive.box<OrderModel>('orders_db')
      : await Hive.openBox<OrderModel>('orders_db');

  final id = await ordersDB.add(newOrder);
  newOrder.id = id;

  ordersListNotifier.value = List.from(ordersListNotifier.value)..add(newOrder);
  ordersListNotifier.notifyListeners();
}

Future<void> getAllOrder() async {
  final ordersDB = Hive.isBoxOpen('orders_db')
      ? Hive.box<OrderModel>('orders_db')
      : await Hive.openBox<OrderModel>('orders_db');

  ordersListNotifier.value = List.from(ordersDB.values);
  ordersListNotifier.notifyListeners();
}

// Income Functions
Future<void> addIncome(IncomeModel newIncome) async {
  final incomeDB = Hive.isBoxOpen('income_db')
      ? Hive.box<IncomeModel>('income_db')
      : await Hive.openBox<IncomeModel>('income_db');

  final id = await incomeDB.add(newIncome);
  newIncome.id = id;

  incomeListNotifier.value = List.from(incomeListNotifier.value)
    ..add(newIncome);
  incomeListNotifier.notifyListeners();
}

Future<void> getAllIncome() async {
  final incomeDB = Hive.isBoxOpen('income_db')
      ? Hive.box<IncomeModel>('income_db')
      : await Hive.openBox<IncomeModel>('income_db');

  incomeListNotifier.value = List.from(incomeDB.values);
  incomeListNotifier.notifyListeners();
}
