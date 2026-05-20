import 'package:flutter/material.dart';
//import '../../widgets/bottom_navbar.dart';
import '../../widgets/question_card.dart'; 
import '../../models/question_data.dart'; 
import '../../widgets/modal_confirm.dart';
import 'results_page.dart';
import '../../models/restaurant_data.dart';
import 'dart:math'; 

class FoodDecisionMaker extends StatefulWidget {
  const FoodDecisionMaker({super.key});

  @override
  State<FoodDecisionMaker> createState() => _FoodDecisionMakerState();
}

class _FoodDecisionMakerState extends State<FoodDecisionMaker> {
  int _currentIndex = 0;
  String? _question2Answer; //track Q2 answer for Q3's dynamic options
  List<String?> _answers = List.filled(6, null); 

  static const _mascotImages = [
    'assets/images/og.png',
    'assets/images/dummy ahh.png',
    'assets/images/shesh.png',
    'assets/images/thinking 2.png',
    'assets/images/thinking 1.png',
    'assets/images/yum.png',
  ];

  String _currentMascot = _mascotImages[Random().nextInt(_mascotImages.length)];

  Question get _currentQuestion => kQuestions[_currentIndex];

  // Resolve options — handles dynamic Q3
  List<String> get _currentOptions {
    if (_currentQuestion.type == "dynamic_single_choice") {
      return _currentQuestion.dynamicOptions?[_question2Answer] ?? [];
    }
    return _currentQuestion.options ?? [];
  }

  void _onChoiceTap(String choice) {
    setState(() {
      _answers[_currentIndex] = choice; // save answer
      if (_currentIndex == 1) _question2Answer = choice;
      _currentMascot = _mascotImages[Random().nextInt(_mascotImages.length)];
    });

    if (_currentIndex < kQuestions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          restaurant: const RestaurantData(
            id: '1',
            name: 'Manang Betch',
            location: 'CUB, Stall #2',
            price: 'Php 5 – Php 100',
            hours: '8am–5pm',
            description: 'Your favorite homecooked meals away from home!',
            tags: ['lunch', 'chicken', 'pork'],
          ),
          onTryAgain: () {
            // Pop result page and reset questions
            Navigator.pop(context);
            setState(() {
              _currentIndex = 0;
              _answers = List.filled(6, null);
              _question2Answer = null;
            });
          },
        ),
      ),
    );
  }
}

  void _onPrevious() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
    _currentMascot = _mascotImages[Random().nextInt(_mascotImages.length)];
  }

  void _onNext() {
    if (_currentIndex < kQuestions.length - 1) setState(() => _currentIndex++);
    _currentMascot = _mascotImages[Random().nextInt(_mascotImages.length)];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: QuestionScreen(
      questionText: _currentQuestion.question,
      currentIndex: _currentIndex + 1,
      total: kQuestions.length,
      choices: _currentOptions,
      mascotImage: _currentMascot,
      onChoiceTap: _onChoiceTap,
      onBack: () {
        showDialog(
          context: context,
          builder: (_) => AdminConfirmModal(
            icon: Icons.restaurant_rounded,
            iconColor: const Color.fromARGB(255, 198, 91, 33),
            iconBgColor: const Color.fromARGB(255, 247, 245, 242),
            title: 'Exit Decisions Page?',
            message: 'Are you sure you want to exit the decisions page?',
            confirmLabel: 'Yes, exit.',
            confirmColor: const Color.fromARGB(255, 198, 91, 33),
            confirmBgColor: const Color.fromARGB(255, 247, 245, 242),
            onConfirm: () {
              Navigator.pop(context);
              Navigator.pop(context);
              },
                  ),
                );
              },
              onPrevious: _currentIndex > 0 ? _onPrevious : null,
              onNext: _answers[_currentIndex] != null ? _onNext : null,
              isTiebreaker: _currentQuestion.questionNumber == 6,
            ),
        );
      }
    }