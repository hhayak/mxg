import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

extension SoftState on RoundedLoadingButtonController {
  void softError([int delaySeconds = 1]) {
    error();
    Future.delayed(Duration(seconds: delaySeconds), () => stop());
  }

  void softSuccess([int delaySeconds = 1]) {
    success();
    Future.delayed(Duration(seconds: delaySeconds),() => stop());
  }
}

class FutureButton extends StatelessWidget {
  final RoundedLoadingButtonController controller;
  final IconData? icon;
  final String? text;
  final double? width;
  final Color? color;
  final double height;
  final VoidCallback? onPressed;

  FutureButton({
    required this.controller,
    this.onPressed,
    this.icon,
    this.text,
    this.width,
    this.color,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: controller,
      onPressed: onPressed,
      height: height,
      width: text != null ? width ?? 100 : 40,
      color: color ?? Theme.of(context).buttonColor,
      borderRadius: 10,
      elevation: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...{
            Padding(
              padding: EdgeInsets.only(right: text != null ? 8 : 0),
              child: Icon(icon),
            )
          },
          if (text != null) ...{
            Padding(
              padding: EdgeInsets.only(right: icon != null ? 8 : 0),
              child: Text(text!),
            ),
          },
        ],
      ),
    );
  }
}
