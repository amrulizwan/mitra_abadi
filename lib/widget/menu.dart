import 'package:flutter/material.dart';
import 'package:mitra_abadi/widget/color.dart';

// ignore: must_be_immutable
class MenuWidget extends StatelessWidget {
  String title;
  IconData icon;
  Function()? onTap = () {};
  MenuWidget({
    required this.title,
    this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 85,
        width: 85,
        decoration: BoxDecoration(
          color: const Color(MyColor.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
