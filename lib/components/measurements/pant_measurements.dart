import 'package:flutter/material.dart';

class PantMeasurements extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const PantMeasurements({Key? key, required this.controllers})
    : super(key: key);

  Widget _buildField(String hint, String key) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controllers.putIfAbsent(key, () => TextEditingController()),
        keyboardType: TextInputType.number,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildField('Length', 'pant_length')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Waist', 'pant_waist')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Seat', 'pant_seat')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Thigh', 'pant_thigh')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Knee Width', 'pant_knee')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Leg Opening', 'pant_leg_opening')),
          ],
        ),
      ],
    );
  }
}
