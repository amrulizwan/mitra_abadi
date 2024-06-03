import 'package:flutter/material.dart';
import 'package:mitra_abadi/widget/color.dart';

// ignore: must_be_immutable
class MyForm extends StatelessWidget {
  TextEditingController? controller;
  int? maxlines;
  String label;
  MyForm({
    this.maxlines,
    this.controller,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        TextField(
          maxLines: maxlines ?? 1,
          controller: controller,
          style: const TextStyle(
              fontSize: 16.0,
              color: Color(MyColor.primary),
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(MyColor.primary),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
      ],
    );
  }
}
