import 'package:flutter/material.dart';

class ShirtMeasurements extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const ShirtMeasurements({Key? key, required this.controllers})
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
            Expanded(child: _buildField('Length', 'shirt_length')),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField('Sleeve Length', 'shirt_sleeve_length'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Collar', 'shirt_collar')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Shoulder', 'shirt_shoulder')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Chest', 'shirt_chest')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Chest Loose', 'shirt_chest_loose')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Waist', 'shirt_waist')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Waist Loose', 'shirt_waist_loose')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Hip', 'shirt_hip')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Hip Loose', 'shirt_hip_loose')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Back Loose', 'shirt_back_loose')),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // empty to balance row
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Pocket Measurements",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildField(
                'Shoulder to Pocket',
                'shirt_pocket_from_shoulder',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField('Pocket Length', 'shirt_pocket_length'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Pocket Width', 'shirt_pocket_width')),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // empty to balance row
          ],
        ),
      ],
    );
  }
}
