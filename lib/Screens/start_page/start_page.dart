import 'package:flutter/material.dart';
import 'package:mind_mystique/Colors.dart' as clrs;
import 'package:mind_mystique/Data/Slots.dart' as slot;
import 'package:mind_mystique/Screens/start_page/common_widgets.dart';

import '../quiz_page/quiz_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool test = true;
  int timeSlot = 0;

  @override
  void initState() {
    checkTimeSlot();
    super.initState();
  }

  checkTimeSlot() {
    timeSlot = test ? 3 : slot.SlotNumber(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrs.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Mind Mystique',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: clrs.textColor),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onLongPress: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => QuizPage(slotNumber: 4,)));
              },
              onPressed: () {
                if (timeSlot != 0) {
                  showStartDialog(context: context, timeSlot: timeSlot);
                } else {
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
                            "The Quiz is over.",
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ok",
                                    style: TextStyle(
                                        fontSize: 18, color: clrs.textColor))),
                          ],
                        );
                      });
                }
              },
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 60, vertical: 30, )),
                  backgroundColor:
                      MaterialStatePropertyAll(clrs.backgroundColor),
                  shadowColor: MaterialStatePropertyAll(Colors.transparent),
                  surfaceTintColor:
                      MaterialStatePropertyAll(Colors.transparent)),
              child: const Text(
                'Play',
                style: TextStyle(fontSize: 45, color: clrs.textColor),
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
                  color: clrs.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
