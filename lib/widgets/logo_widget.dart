import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // custom logo widget
    return Stack(children: [
      Container(
        height: 350,
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(100)),
            color: Colors.white),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            'assets/images/compress.png',
            height: 300,
            width: 200,
          ),
        ),
      ),
    ]);
  }
}
