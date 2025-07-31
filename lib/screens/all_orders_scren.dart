import 'package:flutter/material.dart';
import 'package:hivelocaldb/DB/functions/db_functions.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';
import 'package:hivelocaldb/components/showOrderDetailsBottomSheet.dart';
import 'package:hivelocaldb/screens/qr_screen.dart'; // ✅ New screen
import 'package:hivelocaldb/screens/settings_screen.dart';

class AllOrdersScreen extends StatelessWidget {
  const AllOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QRScreen()),
            );
          },
        ),
        title: const Text(
          "All Order",
          style: TextStyle(color: Color(0xFF0C3B2E)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0C3B2E)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: ValueListenableBuilder<List<OrderModel>>(
          valueListenable: ordersListNotifier,
          builder: (context, List<OrderModel> ordersList, _) {
            if (ordersList.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }

            // 1. Sort by date descending (latest first)
            final sortedOrders = List<OrderModel>.from(ordersList)
              ..sort((a, b) => b.date.compareTo(a.date));

            // 2. Separate uncompleted and completed orders
            final uncompletedOrders = sortedOrders
                .where((order) => !order.completed)
                .toList();
            final completedOrders = sortedOrders
                .where((order) => order.completed)
                .toList();

            // 3. Combine: uncompleted first, then completed
            final finalOrders = [...uncompletedOrders, ...completedOrders];

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: finalOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = finalOrders[index];

                return GestureDetector(
                  onTap: () {
                    showOrderDetailsBottomSheet(context, order);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                order.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (order.completed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("Cloth:  ${order.type}"),
                        Text("Contact:  ${order.contact}"),
                        Text("Date:  ${order.date}"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
