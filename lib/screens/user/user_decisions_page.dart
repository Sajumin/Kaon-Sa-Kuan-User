import 'package:flutter/material.dart';
import 'package:kaon_sa_kuan/data/services/restaurant_service.dart';
import 'package:kaon_sa_kuan/data/static/question_data.dart';
import 'package:kaon_sa_kuan/models/question.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/screens/user/user_results_page.dart';
import 'package:kaon_sa_kuan/widgets/user/modal_confirm.dart';
import 'package:kaon_sa_kuan/widgets/user/question_card.dart';
import 'package:kaon_sa_kuan/data/services/algorithm_result_service.dart';

class FoodDecisionMaker extends StatefulWidget {
  const FoodDecisionMaker({super.key});

  @override
  State<FoodDecisionMaker> createState() => _FoodDecisionMakerState();
}

class _FoodDecisionMakerState extends State<FoodDecisionMaker> {
  final RestaurantService _restaurantService = RestaurantService();
  final AlgorithmResultService _algorithmResultService = AlgorithmResultService();

  int _currentIndex = 0;
  String? _question2Answer;
  List<String?> _answers = List.filled(kQuestions.length, null);

  Question get _currentQuestion => kQuestions[_currentIndex];

  List<String> get _currentOptions {
    if (_currentQuestion.type == QuestionType.dynamicSingleChoice) {
      return _currentQuestion.dynamicOptions?[_question2Answer] ?? [];
    }

    return _currentQuestion.options ?? [];
  }

  void _onChoiceTap(String choice) {
    setState(() {
      _answers[_currentIndex] = choice;

      if (_currentQuestion.questionNumber == 2) {
        _question2Answer = choice;
      }
    });

    if (_currentIndex < kQuestions.length - 1) {
      setState(() => _currentIndex++);
      return;
    }

    _showResult();
  }

  void _showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StreamBuilder<List<Restaurant>>(
          stream: _restaurantService.getRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final restaurants = snapshot.data ?? [];

            if (restaurants.isEmpty) {
              return ResultPage(
                restaurant: null,
                onTryAgain: _resetQuestions,
              );
            }

            final recommended = _algorithmResultService.pickRestaurant(
              restaurants: restaurants,
              answers: _answers,
            );

            return ResultPage(
              restaurant: recommended,
              onTryAgain: _resetQuestions,
            );
          },
        ),
      ),
    );
  }

  void _resetQuestions() {
    Navigator.pop(context);

    setState(() {
      _currentIndex = 0;
      _question2Answer = null;
      _answers = List.filled(kQuestions.length, null);
    });
  }

  void _onPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _onNext() {
    if (_currentIndex < kQuestions.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (_) => UserConfirmModal(
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
        onChoiceTap: _onChoiceTap,
        onBack: _confirmExit,
        onPrevious: _currentIndex > 0 ? _onPrevious : null,
        onNext: _answers[_currentIndex] != null ? _onNext : null,
        isTiebreaker: _currentQuestion.questionNumber == 6,
      ),
    );
  }
}