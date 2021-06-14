import 'package:flutter/material.dart';

class FlatCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color color;
  final bool elevated;
  late final Color fillColor;
  late final Color borderColor;

  FlatCard.outlined({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.elevated = false,
    required this.color,
  }) : super(key: key) {
    fillColor = Colors.transparent;
    borderColor = color;
  }

  FlatCard.filled({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.elevated = false,
    required this.color,
  }) {
    fillColor = color;
    borderColor = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: borderColor),
        color: fillColor,
        boxShadow: elevated ? [BoxShadow(
            color: Colors.grey.withOpacity(0.5), spreadRadius: 0.5, blurRadius: 3)] : null,
      ),
      child: child,
    );
  }
}