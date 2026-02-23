import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/vocabulary.dart';

class MemoryEngine {

  List<Vocabulary> words = [];
  int currentIndex = 0;

  // ===== LOAD JSON =====
  Future<void> loadWords() async {

    final data =
        await rootBundle.loadString('assets/vocab.json');

    final List jsonResult = json.decode(data);

    words = jsonResult
        .map((e) => Vocabulary.fromJson(e))
        .toList();

    // 🔥 สุ่มคำศัพท์ทุกครั้งที่โหลด
    words.shuffle(Random());

    // รีเซ็ต index
    currentIndex = 0;
  }

  Vocabulary get currentWord => words[currentIndex];

  int get learnedCount =>
      words.where((w) => w.isLearned).length;

  // ===== SMART REVIEW LIST =====
  List<Vocabulary> get reviewWords {

    final now = DateTime.now();

    final list = words.where((w) {

      if (w.nextReview == null) return false;

      return w.nextReview!.isBefore(now);

    }).toList();

    // 🔥 สุ่ม review ด้วย
    list.shuffle(Random());

    return list;
  }

  // ===== ANSWER =====
  void answer(bool correct) {

    var w = words[currentIndex];

    if (correct) {

      w.correctCount++;
      w.memoryStrength++;

      w.nextReview = DateTime.now().add(
        Duration(days: w.memoryStrength * 2),
      );

      if (w.memoryStrength >= 3) {
        w.state = "MASTERED";
        w.isLearned = true;
      } else {
        w.state = "LEARNING";
      }

    } else {

      w.wrongCount++;
      w.state = "REVIEW";
      w.nextReview = DateTime.now();
    }

    nextWord();
  }

  void nextWord() {

    if (words.isEmpty) return;

    currentIndex =
        (currentIndex + 1) % words.length;
  }
}