import 'package:flutter/material.dart';
import 'package:hivelocaldb/components/csv_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import / Export CSV'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0C3B2E)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF0C3B2E),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await CsvService.importCsv(context);
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Import Orders from CSV"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await CsvService.exportOrdersToCSV(
                  context,
                ); // Pass context here
              },
              icon: const Icon(Icons.download),
              label: const Text("Export Orders to CSV"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
