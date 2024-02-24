import 'dart:async';
import 'package:mind_mystique/Data/questions.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mind_mystique/Colors.dart' as clrs;
import '../lottie_animation.dart';
import 'common_widgets.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.slotNumber});

  final int slotNumber;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int _timeLeft = 80; // Total time for the countdown
  late Timer _timer;
  final List<int?> _questionStatus = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  int counter = 0;
  int _numberOfWords = 5;
  List<String> answerBank = [];
  int score = 0;
  late final AnimationController _controllerCorrect;
  late final AnimationController _controllerWrong;
  bool correctVisible = false;
  bool wrongVisible = false;

  createFields() {
    _focusNodes = List.generate(_numberOfWords, (index) => FocusNode());
    _controllers =
        List.generate(_numberOfWords, (index) => TextEditingController());
  }

  findSlotBank() {
    if (widget.slotNumber == 1) {
      answerBank = QuestionBank().SlotOneQuestions;
    } else if (widget.slotNumber == 2) {
      answerBank = QuestionBank().SlotTwoQuestions;
    } else if (widget.slotNumber == 3) {
      answerBank = QuestionBank().SlotFourQuestions;
    } else if (widget.slotNumber == 4) {
      answerBank = QuestionBank().SlotThreeQuestions;
    } else {
      answerBank = [];
    }
  }

  findWordCount(int index) {
    String word = answerBank[index];
    _numberOfWords = word.length;
  }

  @override
  void initState() {
    findSlotBank();
    createFields();
    findWordCount(0);
    startTimer();
    super.initState();
    _controllerCorrect = AnimationController(vsync: this);
    _controllerWrong = AnimationController(vsync: this);
    addListeners();
  }

  addListeners() {
    _controllerCorrect.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          correctVisible = false;
        });
        _controllerCorrect.reverse();
      }
    });

    _controllerWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          wrongVisible = false;
        });
        _controllerWrong.reverse();
      }
    });
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
            String enteredWords =
                _controllers.map((controller) => controller.text).join();
            debugPrint('Entered words: $enteredWords');
            for (var i = 0; i < _numberOfWords; i++) {
              _focusNodes[i].dispose();
              _controllers[i].dispose();
            }
            if (enteredWords.toLowerCase() ==
                answerBank[counter].toLowerCase()) {
              _questionStatus[counter] = 1;
              debugPrint("$_questionStatus");
            } else {
              _questionStatus[counter] = -1;
              debugPrint("$_questionStatus");
            }

            if (counter < 15) {
              counter++;
              findWordCount(counter);
              createFields();
              _timer.cancel();
              _timeLeft = 80;
              startTimer();
            } else {
              _timer.cancel();
              score = _questionStatus.where((number) => number == 1).length;
              showFinishDialog(context: context, score: score);
            }
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
    _controllerCorrect.dispose();
    _controllerWrong.dispose();
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
        showBackDialog(context: context);
      },
      child: Stack(
        children: [
          Scaffold(
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
            bottomNavigationBar: submitButton(),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
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
                        child: QuestionNumbers(questionStatus: _questionStatus),
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
                        const SizedBox(
                          height: 5,
                        ),
                        WordField(
                            numberOfWords: _numberOfWords,
                            controllers: _controllers,
                            focusNodes: _focusNodes)
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
          LottieAnimation(
            visibleBool: correctVisible,
            controller: _controllerCorrect,
            asset: 'assets/correct.json',
          ),
          LottieAnimation(
            visibleBool: wrongVisible,
            controller: _controllerWrong,
            asset: 'assets/wrong.json',
          ),
        ],
      ),
    );
  }

  Padding submitButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: clrs.secondaryColor,
          ),
          onPressed: () {
            String enteredWords =
                _controllers.map((controller) => controller.text).join();
            debugPrint('Entered words: $enteredWords');
            debugPrint("$counter");
            setState(() {
              if (enteredWords.toLowerCase() ==
                  answerBank[counter].toLowerCase()) {
                _questionStatus[counter] = 1;
                score++;
                if (correctVisible != true) {
                  correctVisible = true;
                  Timer(const Duration(milliseconds: 150), () {
                    _controllerCorrect.forward();
                  });
                }
                debugPrint("$_questionStatus");
              } else {
                // _questionStatus[counter] = -1;
                if (wrongVisible != true) {
                  wrongVisible = true;
                  Timer(const Duration(milliseconds: 150), () {
                    _controllerWrong.forward();
                  });
                }
                debugPrint("$_questionStatus");
              }
            });
          },
          child: const Text(
            "Submit",
            style: TextStyle(color: clrs.textColor),
          )),
    );
  }
}
