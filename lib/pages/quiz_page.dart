import 'dart:async';
import 'package:created_by_sir/customwidgets/question_set_widget.dart';
import 'package:created_by_sir/pages/result_page.dart';
import 'package:created_by_sir/question_set.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizPage extends StatefulWidget {
  static const String routeName = '/';
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String genderGroupValue = 'Male';
  late Timer timer;
  int tick = 300;
  String timeString = '';
  bool hasQuizStarted = false;
  @override
  void didChangeDependencies() {
    setTime();
    super.didChangeDependencies();
  }

  void setTime() {
    timeString = DateFormat('mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(tick * 1000));
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if(tick <= 0) {
        timer.cancel();
        navigateToResult();
      } else {
        setState(() {
          tick--;
          setTime();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
        actions: [
          TextButton(
            onPressed: () {
              timer.cancel();
              navigateToResult();
            },
            child: const Text('FINISH', style: TextStyle(color: Colors.white),),
          )
        ],
      ),
      body: Column(
        children: [
          Text('$timeString', style: TextStyle(fontSize: 50),),
          if(!hasQuizStarted) ElevatedButton(
            onPressed: () {
              setState(() {
                hasQuizStarted = true;
              });
              startTimer();
            },
            child: const Text('Start Quiz'),
          ),
          if(hasQuizStarted) Expanded(
            child: ListView.builder(
              itemCount: questionList.length,
              itemBuilder: (context, index) {
                final question = questionList[index];
                return QuestionSetView(
                  index: index,
                  question: question,
                  onAnswered: (value) {
                    questionList[index].givenAnswer = value;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  navigateToResult() => Navigator.pushReplacementNamed(context, ResultPage.routeName);
}
