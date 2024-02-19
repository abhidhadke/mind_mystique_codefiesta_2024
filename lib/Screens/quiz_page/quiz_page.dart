import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mind_mystique/Data/questions.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mind_mystique/Colors.dart' as clrs;

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.slotNumber});
  final int slotNumber;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _timeLeft = 80; // Total time for the countdown
  late Timer _timer;
  List<int?> _questionStatus = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  int counter = 0;
  int _numberOfWords = 5;
  List<String> answerBank = [];
  int score = 0;

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

  findSlotBank(){
    if(widget.slotNumber == 1){
      answerBank = QuestionBank().SlotOneQuestions;
    }
    else if(widget.slotNumber == 2){
      answerBank = QuestionBank().SlotTwoQuestions;
    }
    else if(widget.slotNumber == 3){
      answerBank = QuestionBank().SlotThreeQuestions;
    }
    else if(widget.slotNumber == 4){
      answerBank = QuestionBank().SlotFourQuestions;
    }
    else{
      answerBank = [];
    }
  }

  findWordCount(int index){
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
            setState(() {
              for (var i = 0; i < _numberOfWords; i++) {
                _focusNodes[i].dispose();
                _controllers[i].dispose();
              }
              setState(() {
                if(enteredWords == answerBank[counter].toLowerCase()){
                  _questionStatus[counter] = 1;
                  score++;
                  debugPrint("$_questionStatus");
                }else{
                  _questionStatus[counter] = -1;
                  debugPrint("$_questionStatus");
                }
              });
              if(counter < 15){
                counter++;
                findWordCount(counter);
                createFields();
                _timer.cancel();
                _timeLeft = 80;
                startTimer();
              }else{
                _timer.cancel();
                showFinishDialog();
              }
            });
          } else {
            _timeLeft--;
          }
        });
      },
    );
  }
  
  showFinishDialog(){
    showDialog(context: context, barrierDismissible: false ,builder: (BuildContext context){
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.green,),
            SizedBox(width: 10,),
            Text("Thank You!", style: TextStyle(color: clrs.textColor, fontWeight: FontWeight.w600, fontSize: 24),)

          ],
        ),
content: RichText(text: TextSpan(text: 'Your Score is: ', style: const TextStyle(color: clrs.textColor, fontSize: 18,), children: [
  TextSpan(text: '$score/15', style: const TextStyle(color: clrs.textColor, fontSize: 18, fontWeight: FontWeight.w700)),
  const TextSpan(text: '\nPlease show this score to the volunteers to record your score.', style: TextStyle(fontSize: 18, color: clrs.textColor))
]), ),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
               textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              ),
              onPressed: (){
                SystemNavigator.pop();
              }, child: const Text("Exit", style: TextStyle(fontSize: 16, color: clrs.backgroundColor),))
        ],
      );
    });
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
                debugPrint('Entered words: $enteredWords');
                debugPrint("$counter");
                setState(() {
                  for (var i = 0; i < _numberOfWords; i++) {
                    _focusNodes[i].dispose();
                    _controllers[i].dispose();
                  }
                  setState(() {
                    if(enteredWords == answerBank[counter].toLowerCase()){
                      _questionStatus[counter] = 1;
                      score++;
                      debugPrint("$_questionStatus");
                    }else{
                      _questionStatus[counter] = -1;
                      debugPrint("$_questionStatus");
                    }
                  });
                  counter++;
                  if(counter < 15){
                    findWordCount(counter);
                    createFields();
                    _timer.cancel();
                    _timeLeft = 80;
                    startTimer();
                  }else{
                    _timer.cancel();
                    debugPrint('$counter 1');
                    showFinishDialog();
                  }
                });
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: clrs.textColor),
              )),
        ),
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
                    child: Wrap(
                      runSpacing: 10,
                      children: List.generate(15, (index){
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
        ),
      ),
    );
  }
}
