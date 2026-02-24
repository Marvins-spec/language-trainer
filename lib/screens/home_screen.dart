import 'dart:math';
import 'package:flutter/material.dart';

import '../engine/memory_engine.dart';
import '../models/idiom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {

  final MemoryEngine engine = MemoryEngine();

  bool showMeaning = false;
  bool showIdiom = false;
  bool loading = true;

  bool showXP = false;

  Offset cardOffset = Offset.zero;

  Idiom idiom = Idiom(
    idiom: "Break the ice",
    meaning: "เริ่มทำให้บรรยากาศไม่อึดอัด",
  );

  @override
  void initState() {
    super.initState();
  
    engine.loadWords().then((_) async {
  
      await engine.loadProgress();  // 🔥 โหลดค่าที่เคยบันทึก
  
      setState(() {
        loading = false;
      });
  
    });
  }

  // ===== XP =====
  void triggerXP() {
    setState(() {
      showXP = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          showXP = false;
        });
      }
    });
  }

  // ===== Finish Swipe =====
  void finishSwipe(bool correct) {

    if (correct) {
      triggerXP();
    }

    engine.answer(correct);

    setState(() {
      cardOffset = Offset.zero;
      showMeaning = false;

      if (Random().nextInt(4) == 0) {
        showIdiom = true;
      }
    });
  }

  // ===== Daily Goal Ring =====
  Widget buildGoalRing() {

    double progress =
        engine.words.isEmpty
            ? 0
            : engine.learnedCount /
                engine.words.length;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [

          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: Colors.white,
              color: Colors.green,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Daily Goal",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== CARD =====
  Widget buildCard(var word) {

    double rotation = cardOffset.dx / 300;

    return GestureDetector(

      onTap: () {
        setState(() {
          showMeaning = !showMeaning;
        });
      },

      onHorizontalDragUpdate: (details) {
        setState(() {
          cardOffset += Offset(details.delta.dx, 0);
        });
      },

      onHorizontalDragEnd: (_) {

        if (cardOffset.dx > 120) {
          setState(() {
            cardOffset = const Offset(500, 0);
          });

          Future.delayed(
            const Duration(milliseconds: 180),
            () => finishSwipe(true),
          );
        }
        else if (cardOffset.dx < -120) {
          setState(() {
            cardOffset = const Offset(-500, 0);
          });

          Future.delayed(
            const Duration(milliseconds: 180),
            () => finishSwipe(false),
          );
        }
        else {
          setState(() {
            cardOffset = Offset.zero;
          });
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        transform: Matrix4.identity()
          ..translate(cardOffset.dx, 0.0)
          ..rotateZ(rotation),

        width: 330,
        height: 440,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(0, 10),
              color: Colors.black12,
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "📘 Vocabulary",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              word.word,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(word.pos),
            ),

            const SizedBox(height: 22),

            if (showMeaning) ...[

              Text(
                word.meaningEn,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 8),

              Text(
                "แปล: ${word.meaningTh}",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                "Example:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Text(
                word.example,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),

            ] else
              const Text(
                "Tap to reveal meaning",
                style: TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final word = engine.currentWord;
    final nextWord =
        engine.words[(engine.currentIndex + 1) %
            engine.words.length];

    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF6F7FB),
              Color(0xFFE9EEF5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [

              Column(
                children: [

                  const SizedBox(height: 16),

                  buildGoalRing(),

                  const SizedBox(height: 16),

                  Text(
                    "🔥 ${engine.learnedCount} / ${engine.words.length}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                          // ===== BACK CARD =====
                          Transform.scale(
                            scale: 0.94,
                            child: Container(
                              width: 330,
                              height: 440,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius:
                                    BorderRadius.circular(28),
                              ),
                              child: Center(
                                child: Text(
                                  nextWord.word,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.grey.shade400,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          buildCard(word),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ===== XP =====
              if (showXP)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  top: 120,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    opacity: showXP ? 1 : 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "+1 XP ⭐",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

              // ===== Idiom Popup =====
              if (showIdiom)
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("🎉 Bonus Idiom"),
                          const SizedBox(height: 8),
                          Text(
                            idiom.idiom,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(idiom.meaning),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showIdiom = false;
                              });
                            },
                            child: const Text("Got it"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
