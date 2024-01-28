import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelfront/theme/color.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.icon, {
    this.onTap,
    this.color = Colors.grey,
    this.activeColor = AppColor.primary,
    this.isActive = false,
  });

  final IconData icon;
  final Color color;
  final Color activeColor;
  final bool isActive;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColor.bottomBarColor,
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColor.shadowColor.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0), // changes position of shadow
              ),
          ],
        ),
        child: Container(
      color: isActive ? AppColor.primary : color,
        width: 20,
        height: 20,
          child: Icon(
          icon,
          size: 20,
                ),
        ),
      ),
    );
  }
}
