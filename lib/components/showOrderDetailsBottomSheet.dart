import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivelocaldb/DB/functions/db_functions.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';

void showOrderDetailsBottomSheet(BuildContext context, OrderModel order) {
  final nameController = TextEditingController(text: order.name);
  final typeController = TextEditingController(text: order.type);
  final contactController = TextEditingController(text: order.contact);
  final addressController = TextEditingController(text: order.address);
  final notesController = TextEditingController(text: order.notes);

  final Map<String, TextEditingController> measurementControllers = {
    for (var entry in order.measurements.entries)
      entry.key: TextEditingController(text: entry.value),
  };

  bool isEditable = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(""),
                Text(
                  "Order Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Date: ${order.date.toString().split(' ')[0]}",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),

                _buildField("Customer Name", nameController, isEditable),
                _buildField("Cloth Type", typeController, isEditable),
                _buildField("Contact", contactController, isEditable),
                _buildField("Address", addressController, isEditable),
                _buildField("Notes", notesController, isEditable),

                if (measurementControllers.isNotEmpty) ...[
                  Divider(height: 30),
                  Text(
                    "Measurements",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ...measurementControllers.entries.map((entry) {
                    return _buildField(entry.key, entry.value, isEditable);
                  }).toList(),
                ],

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isEditable
                        ? IconButton(
                            icon: Icon(Icons.save, color: Colors.green),
                            onPressed: () async {
                              final box = await Hive.openBox<OrderModel>(
                                'orders_db',
                              );
                              final updatedMeasurements = {
                                for (var entry
                                    in measurementControllers.entries)
                                  entry.key: entry.value.text,
                              };
                              final updatedOrder = OrderModel(
                                id: order.id,
                                name: nameController.text,
                                type: typeController.text,
                                contact: contactController.text,
                                address: addressController.text,
                                notes: notesController.text,
                                completed: order.completed,
                                measurements: updatedMeasurements,
                                date: order.date,
                              );
                              await box.put(order.id, updatedOrder);
                              getAllOrder();
                              Navigator.pop(context);
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                isEditable = true;
                              });
                            },
                          ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final box = await Hive.openBox<OrderModel>('orders_db');
                        await box.delete(order.id);
                        getAllOrder();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      onPressed: order.completed
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Order already completed!'),
                                ),
                              );
                            }
                          : () async {
                              final amountController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Order Completed'),
                                    content: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Amount Charged',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final amount = double.tryParse(
                                            amountController.text,
                                          );
                                          if (amount != null &&
                                              order.id != null) {
                                            await addIncome(
                                              IncomeModel(
                                                orderId: order.id!,
                                                amount: amount,
                                                date: DateTime.now(),
                                              ),
                                            );
                                            await getAllIncome();
                                            final box =
                                                await Hive.openBox<OrderModel>(
                                                  'orders_db',
                                                );
                                            final updatedOrder = OrderModel(
                                              id: order.id,
                                              name: order.name,
                                              type: order.type,
                                              contact: order.contact,
                                              address: order.address,
                                              notes: order.notes,
                                              completed: true,
                                              measurements: order.measurements,
                                              date: order.date,
                                            );
                                            await box.put(
                                              order.id,
                                              updatedOrder,
                                            );
                                            await getAllOrder();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Order marked as completed!',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                      child: Text('Order Completed'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildField(
  String label,
  TextEditingController controller,
  bool enabled,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      enabled: enabled,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: enabled ? Colors.grey[100] : Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    ),
  );
}
