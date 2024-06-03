// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

import 'color.dart';

class ScanCamera extends StatelessWidget {
  String label;
  File image;
  Widget? child;
  Function()? onPressed;
  ScanCamera(
      {this.child,
      required this.image,
      this.onPressed,
      required this.label,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color(MyColor.primary),
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.camera_alt, size: 30),
              color: const Color(MyColor.primary),
            )
          ],
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                matchTextDirection: true,
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: child)
      ],
    );
  }
}
