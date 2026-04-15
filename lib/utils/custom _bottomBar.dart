import 'package:flutter/material.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/app_text_widget.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: ColorsApp.colorTransparent,
      child: Container(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? ColorsApp.colorPurple : ColorsApp.colorGrey,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  fontFamily: "Poppins",
                  color:
                      isSelected ? ColorsApp.colorPurple : ColorsApp.colorGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
