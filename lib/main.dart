import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';
import 'package:hivelocaldb/mainScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // TEMP: Clear all Hive boxes for a clean start

  if (!Hive.isAdapterRegistered(OrderModelAdapter().typeId)) {
    Hive.registerAdapter(OrderModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(IncomeModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreenNavControl());
  }
}
