import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Widget title;
  final VoidCallback onPressed;
  const RoundButton({super.key, required this.title, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Material(
        child: MaterialButton(
      clipBehavior: Clip.antiAlias,
      onPressed: onPressed,
      minWidth: double.infinity,
      color: Colors.deepOrange,
      height: 40,
      child: title,
    ));
  }
}
