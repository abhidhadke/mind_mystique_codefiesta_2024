import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mind_mystique/Colors.dart' as clrs;

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _timeLeft = 80; // Total time for the countdown
  late Timer _timer;
  final List<int?> _questionStatus = [1, -1, 1, -1, 1, 1, -1, 0, 0, 0];
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  int _numberOfWords = 5;

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

  createFields() {
    _focusNodes = List.generate(_numberOfWords, (index) => FocusNode());
    _controllers =
        List.generate(_numberOfWords, (index) => TextEditingController());
  }

  @override
  void initState() {
    createFields();
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        setState(() {
          if (_timeLeft < 1) {
            Vibration.vibrate();
            timer.cancel(); // Stop the timer when time's up
          } else {
            _timeLeft--;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var i = 0; i < _numberOfWords; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
        backgroundColor: clrs.primaryColor,
        appBar: AppBar(
          title: const Text(
            'Mind Mystique',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: clrs.textColor),
          ),
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: clrs.secondaryColor,
              ),
              onPressed: () {
                String enteredWords =
                    _controllers.map((controller) => controller.text).join();
                print('Entered words: $enteredWords');
                setState(() {
                  for (var i = 0; i < _numberOfWords; i++) {
                    _focusNodes[i].dispose();
                    _controllers[i].dispose();
                  }
                  _numberOfWords = 9;
                  createFields();
                  _timer.cancel();
                  _timeLeft = 80;
                  startTimer();
                });
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: clrs.textColor),
              )),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'Time Remaining: $_timeLeft',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    "Questions:",
                    style: TextStyle(
                        color: clrs.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                )),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
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
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Guess the Word!!",
                  style: TextStyle(
                      color: clrs.textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5,),
                Wrap(
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
                          if (value.isNotEmpty && index < _numberOfWords - 1) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index + 1]);
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
