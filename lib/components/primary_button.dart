import 'package:flutter/material.dart';

import '../constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
    this.isLoading = false,
  });

  final String text;
  final VoidCallback press;
  final Color color;
  final EdgeInsets padding;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      padding: padding,
      color: isLoading ? Colors.grey : color,
      minWidth: double.infinity,
      onPressed: isLoading ? null : press,
      child: isLoading
          ? CircularProgressIndicator(color: color)
          : Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
    );
  }
}
