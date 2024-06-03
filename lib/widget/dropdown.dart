// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'color.dart';

class MyDropdown extends StatelessWidget {
  String label;
  String hint;
  String? value;
  List<String> list;
  Function(String?) onChanged;
  MyDropdown({
    this.value,
    required this.hint,
    required this.onChanged,
    required this.list,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
            color: Color(MyColor.primary),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 3.0,
        ),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: DropdownButton(
            value: value,
            hint: Text(hint),
            isExpanded: true,
            borderRadius: BorderRadius.circular(16),
            items: list.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
