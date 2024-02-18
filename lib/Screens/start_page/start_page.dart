import 'package:flutter/material.dart';
import 'package:mind_mystique/Screens/quiz_page/quiz_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int timeSlot = 1;

  checkTimeSlot() {}

  @override
  void initState() {
    checkTimeSlot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: const Text(
          'Mind Mystique',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Row(
                          children: [
                            Icon(
                              Icons.report_gmailerrorred,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Alert"),
                          ],
                        ),
                        content: const Text(
                          "Once you start the quiz, avoid going back or closing the app. Doing so could lead to automatic disqualification.",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => const QuizPage()));
                              },
                              child: const Text("Start",
                                  style: TextStyle(fontSize: 18))),
                          const SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.redAccent),
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.fromLTRB(15, 10, 15, 10))),
                            child: const Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        ],
                      );
                    });
              },
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.fromLTRB(20, 10, 20, 10))),
              child: const Text(
                'Start',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Time Slot: $timeSlot',
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
