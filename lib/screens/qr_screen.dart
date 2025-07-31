import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String upiID = "UPI ID HERE"; // ✅ Replace with your UPI ID
  double? amount; // Stores entered amount

  @override
  Widget build(BuildContext context) {
    // Generate UPI payment string
    String upiLink = amount != null
        ? "upi://pay?pa=$upiID&pn=SHOP NAME HERE&am=${amount!.toStringAsFixed(2)}&cu=INR" //✅ Replace with your shop name
        : "upi://pay?pa=$upiID&pn=SHOP NAME HERE&cu=INR"; //✅ Replace with your shop name

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("UPI QR Code"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0C3B2E)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // ✅ Allows scrolling when keyboard opens
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // ✅ Fixed QR area to avoid shifting
                SizedBox(
                  height: 300,
                  width: 300,
                  child: QrImageView(
                    data: upiLink,
                    version: QrVersions.auto,
                    size: 250.0,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  amount != null
                      ? "Pay ₹${amount!.toStringAsFixed(2)} to $upiID"
                      : "Scan to pay any amount to $upiID",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _showAmountDialog,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "Enter Amount",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    backgroundColor: Colors.green[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows input dialog for entering amount
  void _showAmountDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Amount"),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: "Enter amount in ₹"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double? enteredAmount = double.tryParse(controller.text);
                if (enteredAmount != null && enteredAmount > 0) {
                  setState(() {
                    amount = enteredAmount;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Generate QR"),
            ),
          ],
        );
      },
    );
  }
}
