import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CsvService {
  /// ----------------- EXPORT ORDERS -----------------
  static Future<void> exportOrdersToCSV(BuildContext context) async {
    try {
      if (!(await Permission.storage.request().isGranted)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      if (!Hive.isBoxOpen('orders_db')) {
        await Hive.openBox<OrderModel>('orders_db');
      }
      final box = Hive.box<OrderModel>('orders_db');
      if (box.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No orders to export')));
        return;
      }

      final rows = <List<dynamic>>[
        [
          'ID',
          'Name',
          'Type',
          'Contact',
          'Address',
          'Notes',
          'Completed',
          'Measurements',
          'Date',
        ],
      ];

      for (var order in box.values) {
        rows.add([
          order.id ?? '',
          order.name,
          order.type,
          order.contact,
          order.address ?? '',
          order.notes ?? '',
          'true',
          order.measurements.entries
              .map((e) => '${e.key}:${e.value}')
              .join(', '),
          order.date.toIso8601String(),
        ]);
      }

      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      final dir = dirs?.first;
      if (dir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get storage directory')),
        );
        return;
      }

      final file = File('${dir.path}/orders.csv');
      await file.writeAsString(const ListToCsvConverter().convert(rows));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Orders exported to ${file.path}')),
      );
    } catch (e, stacktrace) {
      print('Error exporting orders: $e\n$stacktrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export orders: $e')));
    }
  }

  /// ----------------- EXPORT INCOME -----------------
  static Future<void> exportIncomeToCSV(BuildContext context) async {
    try {
      if (!(await Permission.storage.request().isGranted)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      if (!Hive.isBoxOpen('income_db')) {
        await Hive.openBox<IncomeModel>('income_db');
      }
      final box = Hive.box<IncomeModel>('income_db');
      if (box.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No income data to export')),
        );
        return;
      }

      final rows = <List<dynamic>>[
        ['ID', 'OrderID', 'Amount', 'Date'],
      ];

      for (var income in box.values) {
        rows.add([
          income.id ?? '',
          income.orderId,
          income.amount,
          income.date.toIso8601String(),
        ]);
      }

      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      final dir = dirs?.first;
      if (dir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get storage directory')),
        );
        return;
      }

      final file = File('${dir.path}/income.csv');
      await file.writeAsString(const ListToCsvConverter().convert(rows));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Income exported to ${file.path}')),
      );
    } catch (e, stacktrace) {
      print('Error exporting income: $e\n$stacktrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export income: $e')));
    }
  }

  /// ----------------- IMPORT MULTIPLE CSV FILES WITH AUTO DETECTION -----------------
  static Future<void> importCsv(BuildContext context) async {
    try {
      if (!(await Permission.storage.request().isGranted)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      if (result == null || result.files.isEmpty) return;

      for (final pickedFile in result.files) {
        final path = pickedFile.path;
        if (path == null || !path.toLowerCase().endsWith('.csv')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Skipping non-CSV file: ${pickedFile.name}'),
            ),
          );
          continue;
        }

        final file = File(path);
        final content = await file.readAsString();
        final rows = const CsvToListConverter().convert(content);

        if (rows.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV is empty: ${pickedFile.name}')),
          );
          continue;
        }

        final header = rows.first
            .map((e) => e.toString().trim().toLowerCase())
            .toList();

        // ---------------- ORDERS ----------------
        if (header.contains('name') && header.contains('type')) {
          if (!Hive.isBoxOpen('orders_db')) {
            await Hive.openBox<OrderModel>('orders_db');
          }
          final box = Hive.box<OrderModel>('orders_db');

          for (int i = 1; i < rows.length; i++) {
            final row = rows[i];
            if (row.isEmpty) continue;

            final measurements = <String, String>{};
            if (row.length > 7 &&
                (row[7]?.toString().trim().isNotEmpty ?? false)) {
              for (var part in row[7].toString().split(',')) {
                final split = part.split(':');
                if (split.length == 2) {
                  measurements[split[0].trim()] = split[1].trim();
                }
              }
            }

            final model = OrderModel(
              id: row.isNotEmpty
                  ? int.tryParse(row[0]?.toString() ?? '')
                  : null,
              name: row.length > 1 ? row[1]?.toString() ?? '' : '',
              type: row.length > 2 ? row[2]?.toString() ?? '' : '',
              contact: row.length > 3 ? row[3]?.toString() ?? '' : '',
              address: row.length > 4 ? row[4]?.toString() ?? '' : '',
              notes: row.length > 5 ? row[5]?.toString() ?? '' : '',
              completed: row.length > 6
                  ? (row[6] == true ||
                        row[6].toString().toLowerCase() == 'true')
                  : false,
              measurements: measurements,
              date: row.length > 8
                  ? DateTime.tryParse(row[8]?.toString() ?? '') ??
                        DateTime.now()
                  : DateTime.now(),
            );

            await box.add(model);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Imported orders from ${pickedFile.name}'),
            ),
          );
        }
        // ---------------- INCOME ----------------
        else if (header.contains('orderid') && header.contains('amount')) {
          if (!Hive.isBoxOpen('income_db')) {
            await Hive.openBox<IncomeModel>('income_db');
          }
          final box = Hive.box<IncomeModel>('income_db');

          for (int i = 1; i < rows.length; i++) {
            final row = rows[i];
            if (row.isEmpty) continue;

            final model = IncomeModel(
              id: row.isNotEmpty
                  ? int.tryParse(row[0]?.toString() ?? '')
                  : null,
              orderId: row.length > 1
                  ? int.tryParse(row[1]?.toString() ?? '') ?? 0
                  : 0,
              amount: row.length > 2
                  ? double.tryParse(row[2]?.toString() ?? '') ?? 0
                  : 0,
              date: row.length > 3
                  ? DateTime.tryParse(row[3]?.toString() ?? '') ??
                        DateTime.now()
                  : DateTime.now(),
            );

            await box.add(model);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Imported income from ${pickedFile.name}'),
            ),
          );
        }
        // ---------------- UNKNOWN FORMAT ----------------
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Unknown CSV format: ${pickedFile.name}')),
          );
        }
      }
    } catch (e, stacktrace) {
      print('Failed to import CSV: $e\n$stacktrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to import CSV: $e')));
    }
  }
}
