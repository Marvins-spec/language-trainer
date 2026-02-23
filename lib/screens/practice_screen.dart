import 'dart:math';
import 'package:flutter/material.dart';
import '../engine/memory_engine.dart';

class PracticeScreen extends StatefulWidget {
  final List? reviewWords;

  const PracticeScreen({
    super.key,
    this.reviewWords,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {

  final MemoryEngine engine = MemoryEngine();

  bool loading = true;

  // 🔥 STREAK SYSTEM
  int currentStreak = 0;
  int bestStreak = 0;

  int correctCount = 0;
  int wrongCount = 0;

  String? selectedAnswer;
  bool? isCorrectAnswer;

  String? feedbackText;
  Color feedbackColor = Colors.transparent;

  List<String> currentChoices = [];

  @override
  void initState() {
    super.initState();

    engine.loadWords().then((_) {

      if (widget.reviewWords != null) {
        engine.words = widget.reviewWords!.cast();
        engine.words.shuffle();
        engine.currentIndex = 0;
      }

      setState(() {
        loading = false;
        loadChoices();
      });
    });
  }

  List<String> generateChoices() {

    final correct = engine.currentWord.meaningTh;
    List<String> choices = [correct];
    final random = Random();

    while (choices.length < 4) {
      final w = engine.words[random.nextInt(engine.words.length)];

      if (!choices.contains(w.meaningTh)) {
        choices.add(w.meaningTh);
      }
    }

    choices.shuffle();
    return choices;
  }

  void loadChoices() {
    currentChoices = generateChoices();
  }

  void finishAnswer(bool correct) {

    if (correct) {
      correctCount++;
      currentStreak++;

      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }

    } else {
      wrongCount++;
      currentStreak = 0; // ❌ ผิด = รีเซ็ต
    }

    engine.answer(correct);

    setState(() {
      selectedAnswer = null;
      feedbackText = null;
      loadChoices();
    });
  }

  // ===== QUIZ CARD UI =====
  Widget buildQuiz(word) {

    final choices = currentChoices;

    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            "🧠 Choose the correct meaning",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            word.word,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ...choices.map((c) {

            bool isSelected = selectedAnswer == c;
            Color? bg;

            if (isSelected) {
              bg = isCorrectAnswer == true
                  ? Colors.green
                  : Colors.red;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  backgroundColor: bg,
                ),
                onPressed: () {

                  if (selectedAnswer != null) return;

                  bool correct = c == word.meaningTh;

                  setState(() {
                    selectedAnswer = c;
                    isCorrectAnswer = correct;

                    feedbackText = correct
                        ? "✔ Correct!"
                        : "❌ Wrong\nCorrect: ${word.meaningTh}";

                    feedbackColor =
                        correct ? Colors.green : Colors.red;
                  });

                  Future.delayed(
                    const Duration(milliseconds: 900),
                    () => finishAnswer(correct),
                  );
                },
                child: Text(c),
              ),
            );
          }),

          if (feedbackText != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: feedbackColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedbackText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: feedbackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final word = engine.currentWord;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 16),

            const Text(
              "Practice Quiz",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // 🔥 STREAK DISPLAY
            Text(
              "🔥 Streak: $currentStreak   🏆 Best: $bestStreak",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),


            Expanded(
              child: Center(
                child: buildQuiz(word),
              ),
            ),
          ],
        ),
      ),
    );
  }
}