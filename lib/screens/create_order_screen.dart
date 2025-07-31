import 'package:flutter/material.dart';
import 'package:hivelocaldb/DB/functions/db_functions.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';
import 'package:hivelocaldb/components/measurements/blouse_measurements.dart';
import 'package:hivelocaldb/components/measurements/churidar_measurements.dart';
import 'package:hivelocaldb/components/measurements/coat_measurements.dart';
import 'package:hivelocaldb/components/measurements/pant_measurements.dart';
import 'package:hivelocaldb/components/measurements/shirt_measurements.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final List<String> clothTypes = [
    'Blouse',
    'Churidar',
    'Top',
    'Coat',
    'Shirt',
    'Pant',
  ];
  String? selectedClothType;

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  final Map<String, TextEditingController> _measurementControllers = {};

  Widget? getMeasurementWidget() {
    switch (selectedClothType) {
      case 'Blouse':
        return BlouseMeasurements(controllers: _measurementControllers);
      case 'Churidar':
      case 'Top':
        return ChuridarMeasurements(controllers: _measurementControllers);
      case 'Coat':
        return CoatMeasurements(controllers: _measurementControllers);
      case 'Shirt':
        return ShirtMeasurements(controllers: _measurementControllers);
      case 'Pant':
        return PantMeasurements(controllers: _measurementControllers);
      default:
        return const Text("Select a cloth type to enter measurements");
    }
  }

  void clearAllFields() {
    _nameController.clear();
    _contactController.clear();
    _addressController.clear();
    _notesController.clear();
    _measurementControllers.values.forEach((c) => c.clear());
    setState(() {
      selectedClothType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create Order",
          style: TextStyle(
            color: Color(0xFF0C3B2E),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0C3B2E)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            sectionTitle("Customer Info"),
            inputBox(hint: "Customer Name", controller: _nameController),
            const SizedBox(height: 16),
            inputBox(
              hint: "Phone Number",
              keyboardType: TextInputType.phone,
              controller: _contactController,
            ),
            const SizedBox(height: 16),
            inputBox(
              hint: "Customer's Address",
              controller: _addressController,
              maxLines: 3,
            ),
            const SizedBox(height: 28),

            sectionTitle("Cloth Type"),
            clothTypeSelector(),
            const SizedBox(height: 28),

            sectionTitle("Measurements"),
            getMeasurementWidget() ?? Container(),
            const SizedBox(height: 28),

            sectionTitle("Order Notes"),
            inputBox(
              hint: "Any special instructions",
              maxLines: 3,
              controller: _notesController,
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: clearAllFields,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Clear", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final Map<String, String> measurements = {};
                      _measurementControllers.forEach((key, controller) {
                        measurements[key] = controller.text.trim();
                      });

                      final order = OrderModel(
                        name: _nameController.text.trim(),
                        contact: _contactController.text.trim(),
                        address: _addressController.text.trim(),
                        notes: _notesController.text.trim(),
                        type: selectedClothType ?? '',
                        date: DateTime.now(),
                        measurements: measurements,
                      );

                      addOrder(order);
                      clearAllFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C3B2E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save Order",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget inputBox({
    String hint = "",
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget clothTypeSelector() {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: clothTypes.map((type) {
            return ListTile(
              title: Text(
                type,
                style: const TextStyle(color: Color(0xFF0C3B2E)),
              ),
              onTap: () {
                setState(() {
                  selectedClothType = type;
                  _measurementControllers.clear();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedClothType ?? "Select cloth type",
              style: TextStyle(
                color: selectedClothType != null ? Colors.black : Colors.grey,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF0C3B2E)),
          ],
        ),
      ),
    );
  }
}
