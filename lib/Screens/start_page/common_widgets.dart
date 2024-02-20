import 'package:flutter/material.dart';
import 'package:mind_mystique/Colors.dart' as clrs;
import '../quiz_page/quiz_page.dart';


showStartDialog({required BuildContext context, required int timeSlot}){
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
                          builder: (_) => QuizPage(slotNumber: timeSlot,)));
                },
                child: const Text("Start",
                    style: TextStyle(fontSize: 18, color: clrs.textColor))),
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
}