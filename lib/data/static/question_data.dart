import 'package:kaon_sa_kuan/models/question.dart';
import 'package:kaon_sa_kuan/utils/constants/restaurant_tags.dart';

// ── Static question data (swap with Firestore fetch later) ────────────────────

const List<Question> kQuestions = [
  Question(
    questionNumber: 1,
    question: "What's your budget?",
    type: QuestionType.singleChoice,
    options: [
      "Below PHP 80",
      "PHP 81 - PHP 150",
      "PHP 151 - PHP 300",
      "PHP 300+",
    ],
    purpose: "Filters restaurants by budgetTags / averageCost",
  ),
  Question(
    questionNumber: 2,
    question: "What are you in the mood for?",
    type: QuestionType.singleChoice,
    options: [
      "Full Meal",
      "Grilled / Seafood",
      "Desserts / Snacks",
      "Premium / Group Dining",
      "Not Sure",
    ],
    purpose: "Matches broad foodCategory first",
  ),
  Question(
    questionNumber: 3,
    question: "What specifically are you craving?",
    type: QuestionType.dynamicSingleChoice,
    dependsOnQuestionNumber: 2,
    dynamicOptions: {
      "Full Meal":               ["Karinderya", "Silog", "Ilonggo"],
      "Grilled / Seafood":       ["Ihaw", "Seafood"],
      "Desserts / Snacks":       ["Pastry", "Street Food"],
      "Premium / Group Dining":  ["Samgyup"],
      "Not Sure":                ["Savory", "Sweet", "Grilled"],
    },
    purpose: "Matches exact foodType",
  ),
  Question(
    questionNumber: 4,
    question: "Where do you want to eat?",
    type: QuestionType.singleChoice,
    options: [
      ...RestaurantOptions.locations,
      "Anywhere",
    ],
    purpose: "Filters by preferred location",
  ),
  Question(
    questionNumber: 5,
    question: "What are you looking for right now?",
    type: QuestionType.singleChoice,
    options: [
      "Breakfast",
      "Lunch",
      "Merienda",
      "Dinner",
    ],
    purpose: "Matches mealTags + checks openTime/closeTime",
  ),
  Question(
    questionNumber: 6,
    question: "What matters most to you?",
    type: QuestionType.singleChoice,
    options: [
      "Cheapest Option",
      "Best Food Match",
    ],
    purpose: "Used only for tie-breakers",
  ),
];