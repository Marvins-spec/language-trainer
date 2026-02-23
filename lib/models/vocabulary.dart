class Vocabulary {

  final String word;
  final String pos;
  final String meaningEn;
  final String meaningTh;
  final String example;

  // ===== MEMORY =====
  int memoryStrength;
  int correctCount;
  bool isLearned;

  // ===== SMART REVIEW =====
  DateTime? nextReview;
  String state;
  int wrongCount;

  Vocabulary({
    required this.word,
    required this.pos,
    required this.meaningEn,
    required this.meaningTh,
    required this.example,
    this.memoryStrength = 0,
    this.correctCount = 0,
    this.isLearned = false,
    this.nextReview,
    this.state = "NEW",
    this.wrongCount = 0,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json["word"],
      pos: json["pos"],
      meaningEn: json["meaningEn"],
      meaningTh: json["meaningTh"],
      example: json["example"],
    );
  }
}
