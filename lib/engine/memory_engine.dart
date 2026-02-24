import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/vocabulary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryEngine {

  List<Vocabulary> words = [];
  int currentIndex = 0;

  // FIX
  Future<void> saveProgress() async {
  final prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> progressMap = {};

  for (var w in words) {
    progressMap[w.word] = {
      "correctCount": w.correctCount,
      "wrongCount": w.wrongCount,
      "memoryStrength": w.memoryStrength,
      "isLearned": w.isLearned,
      "state": w.state,
      "nextReview": w.nextReview?.toIso8601String(),
    };
  }

  await prefs.setString(
      "progress", jsonEncode(progressMap));
}

  // load save
  Future<void> loadProgress() async {
  final prefs = await SharedPreferences.getInstance();

  final savedData = prefs.getString("progress");

  if (savedData == null) return;

  final Map<String, dynamic> progressMap =
      jsonDecode(savedData);

  for (var w in words) {
    if (progressMap.containsKey(w.word)) {
      var data = progressMap[w.word];

      w.correctCount = data["correctCount"];
      w.wrongCount = data["wrongCount"];
      w.memoryStrength = data["memoryStrength"];
      w.isLearned = data["isLearned"];
      w.state = data["state"];

      if (data["nextReview"] != null) {
        w.nextReview =
            DateTime.parse(data["nextReview"]);
      }
    }
  }
}


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
  void answer(bool correct) async {
  
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
  
    await saveProgress();   // 🔥 เพิ่มบรรทัดนี้
  
    nextWord();
  }
}
