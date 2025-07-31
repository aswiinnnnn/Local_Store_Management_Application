import 'package:flutter/material.dart';

class CoatMeasurements extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const CoatMeasurements({Key? key, required this.controllers})
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
            Expanded(child: _buildField('Length', 'coat_length')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Waist', 'coat_waist')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Chest', 'coat_chest')),

            const SizedBox(width: 12),

            Expanded(child: _buildField('Chest Loose', 'coat_chest_loose')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Sleeve Length', 'coat_sleeve_length')),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField('Sleeve First Size', 'coat_sleeve_first'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildField('Sleeve Second Size', 'coat_sleeve_second'),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // empty to balance row
          ],
        ),
      ],
    );
  }
}
