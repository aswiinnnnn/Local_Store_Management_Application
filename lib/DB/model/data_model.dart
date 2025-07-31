import 'package:hive_flutter/adapters.dart';

part 'data_model.g.dart';

@HiveType(typeId: 1)
class OrderModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String contact;

  @HiveField(4)
  final String? address;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  bool completed;

  @HiveField(7)
  final Map<String, String> measurements;

  @HiveField(8)
  final DateTime date; // 🆕 added date field

  OrderModel({
    required this.name,
    required this.type,
    required this.contact,
    this.address,
    this.notes,
    this.id,
    this.completed = false,
    this.measurements = const {},
    required this.date, // 🆕 required date
  });
}

@HiveType(typeId: 2)
class IncomeModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final int orderId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  IncomeModel({
    required this.orderId,
    required this.amount,
    required this.date,
    this.id,
  });
}
