import 'package:flutter/material.dart';

class BottomNavigationIcon extends StatelessWidget {
  final IconData icon;
  final int quantity;
  const BottomNavigationIcon({
    required this.icon,
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
          size: 35,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            minRadius: 8,
            maxRadius: 8,
            backgroundColor: Colors.red,
            child: Center(
              child: FittedBox(
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
