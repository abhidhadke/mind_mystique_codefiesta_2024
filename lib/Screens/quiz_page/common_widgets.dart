import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_mystique/Colors.dart' as clrs;

void showBackDialog({required BuildContext context}) {
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
            child: const Text('Nevermind', style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 15,
          ),
          TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10)),
            child: const Text(
              'Leave',
              style: TextStyle(color: clrs.backgroundColor, fontSize: 18),
            ),
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

showFinishDialog({required BuildContext context, required int score}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Thank You!",
                style: TextStyle(
                    color: clrs.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              )
            ],
          ),
          content: RichText(
            text: TextSpan(
                text: 'Your Score is: ',
                style: const TextStyle(
                  color: clrs.textColor,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                      text: '$score/15',
                      style: const TextStyle(
                          color: clrs.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const TextSpan(
                      text:
                      '\nPlease show this score to the volunteers to record your score.',
                      style: TextStyle(fontSize: 18, color: clrs.textColor))
                ]),
          ),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(fontSize: 16, color: clrs.backgroundColor),
                ))
          ],
        );
      });
}

class WordField extends StatelessWidget {
  const WordField({
    super.key,
    required int numberOfWords,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
  }) : _numberOfWords = numberOfWords, _controllers = controllers, _focusNodes = focusNodes;

  final int _numberOfWords;
  final List<TextEditingController> _controllers;
  final List<FocusNode> _focusNodes;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(
        _numberOfWords,
            (index) => SizedBox(
          width: 50,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.text,
            maxLength: 1,
            // Restrict input length to one character
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              counterText: '', // Hide character counter
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty &&
                  index < _numberOfWords - 1) {
                FocusScope.of(context)
                    .requestFocus(_focusNodes[index + 1]);
              }
            },
          ),
        ),
      ),
    );
  }
}

class QuestionNumbers extends StatelessWidget {
  const QuestionNumbers({
    super.key,
    required List<int?> questionStatus,
  }) : _questionStatus = questionStatus;

  final List<int?> _questionStatus;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      children: List.generate(15, (index) {
        Color color = _questionStatus[index]! == 1
            ? Colors.green
            : _questionStatus[index]! == -1
            ? Colors.red
            : Colors.grey;

        // Determine the icon based on the question status
        IconData icon = _questionStatus[index]! == 1
            ? Icons.check
            : _questionStatus[index]! == -1
            ? Icons.close
            : Icons.question_mark_rounded;

        return SizedBox(
          width: 50,
          child: CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
