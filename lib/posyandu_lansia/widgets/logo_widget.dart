import 'package:flutter/material.dart';

class LansCareLogo extends StatelessWidget {
  final double size;
  const LansCareLogo({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
    );
  }
}
