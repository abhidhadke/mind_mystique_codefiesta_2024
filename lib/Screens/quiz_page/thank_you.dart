import 'package:flutter/material.dart';
import 'package:mind_mystique/Colors.dart';
import 'package:mind_mystique/Screens/quiz_page/common_widgets.dart';
import 'dart:async';

class ThankYou extends StatefulWidget {
  const ThankYou({super.key, required this.score});
  final int score;

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      showFinishDialog(context: context, score: widget.score);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [Container(

        ),]
      ),
    );
  }
}
