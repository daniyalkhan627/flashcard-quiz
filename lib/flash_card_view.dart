import 'package:flutter/material.dart';

class FlashCardView extends StatelessWidget {
  final String text;

  const FlashCardView({super.key, required this.text}) ;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


