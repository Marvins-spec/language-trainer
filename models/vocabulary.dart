class Vocabulary {
  final String word;
  final String pos;
  final String meaning;
  final String example;

  int memoryStrength;
  int correctCount;
  bool isLearned;

  Vocabulary({
    required this.word,
    required this.pos,
    required this.meaning,
    required this.example,
    this.memoryStrength = 0,
    this.correctCount = 0,
    this.isLearned = false,
  });
}
