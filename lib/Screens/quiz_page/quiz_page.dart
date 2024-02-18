import 'package:flutter/material.dart';


class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Leaving now will result in disqualification and data loss. Continue?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind', style: TextStyle( fontSize: 18)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 15,),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10)
              ),
              child: const Text('Leave', style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop){
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          title: const Text('Mind Mystique',
              style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black54),),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
