import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;

  const CardContainer({
    required this.child,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.transparent,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors.map((color) => color.withOpacity(0.1)).toList(),
        ),
      ),
      child: child,
    );
  }
}
