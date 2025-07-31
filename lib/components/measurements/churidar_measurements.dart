import 'package:flutter/material.dart';

class ChuridarMeasurements extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final void Function(String field, String value)? onValueChange;
  final void Function(String)? onCollarSelect;
  final void Function(String)? onOpenSelect;
  final void Function(String)? onNeckModelSelect;

  const ChuridarMeasurements({
    Key? key,
    required this.controllers,
    this.onValueChange,
    this.onCollarSelect,
    this.onOpenSelect,
    this.onNeckModelSelect,
  }) : super(key: key);

  @override
  State<ChuridarMeasurements> createState() => _ChuridarMeasurementsState();
}

class _ChuridarMeasurementsState extends State<ChuridarMeasurements> {
  bool collarNeeded = false;
  bool isOpen = false;

  TextEditingController _ensureController(String key) {
    return widget.controllers.putIfAbsent(key, () => TextEditingController());
  }

  Widget _buildField(String hint, String key) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: _ensureController(key),
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
        onChanged: (value) => widget.onValueChange?.call(key, value),
      ),
    );
  }

  void _showNeckModelSelector(BuildContext context) {
    final options = ['Round Neck', 'Square Neck', 'V Neck', 'Aalila Shape'];
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: options.length,
        itemBuilder: (_, index) {
          final item = options[index];
          return ListTile(
            title: Text(item),
            onTap: () {
              _ensureController('neck_model').text = item;
              widget.onNeckModelSelect?.call(item);
              Navigator.pop(context);
              setState(() {});
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Fields (Chest, Sleeves, etc.)
        Row(
          children: [
            Expanded(child: _buildField('Chest', 'chest')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Chest Loose', 'chest_loose')),
          ],
        ),

        Row(
          children: [
            Expanded(child: _buildField('Shoulder', 'shoulder')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Waist', 'waist')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Hip', 'hip')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Slit', 'slit')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Sleeve Length', 'sleeve_length')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Sleeve First Size', 'sleeve_first')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Sleeve Second Size', 'sleeve_second')),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),

        Row(
          children: [
            Expanded(child: _buildField('Neck Front', 'neck_front')),
            const SizedBox(width: 12),
            Expanded(child: _buildField('Neck Back', 'neck_back')),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildField('Neck Wide', 'neck_wide')),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),

        // Toggle Switches
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                title: const Text('Collar'),
                value: collarNeeded,
                onChanged: (val) {
                  setState(() => collarNeeded = val);
                  widget.onValueChange?.call('collar_needed', val.toString());
                },
              ),
            ),
            Expanded(
              child: SwitchListTile(
                title: const Text('Open'),
                value: isOpen,
                onChanged: (val) {
                  setState(() => isOpen = val);
                  widget.onValueChange?.call('is_open', val.toString());
                },
              ),
            ),
          ],
        ),

        // Neck Model Selector
        GestureDetector(
          onTap: () => _showNeckModelSelector(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _ensureController('neck_model').text.isEmpty
                      ? 'Select Neck Model'
                      : _ensureController('neck_model').text,
                  style: const TextStyle(color: Colors.grey),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
