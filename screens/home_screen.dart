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

  MemoryEngine engine = MemoryEngine();
  bool showMeaning = false;
  bool showIdiom = false;

  Idiom idiom = Idiom(
    idiom: "Break the ice",
    meaning: "make people feel comfortable",
  );

  void answer(bool correct) {
    setState(() {
      engine.answer(correct);
      showMeaning = false;

      if (Random().nextInt(4) == 0) {
        showIdiom = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final word = engine.currentWord;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [

                const SizedBox(height: 20),

                Text(
                  "You truly learned ${engine.learnedCount} / ${engine.words.length}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: Center(
                    child: GestureDetector(

                      onTap: () {
                        setState(() {
                          showMeaning = !showMeaning;
                        });
                      },

                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          answer(true); // จำได้
                        } else {
                          answer(false); // ยังไม่รู้
                        }
                      },

                      child: AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 200),
                        width: 320,
                        height: 420,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black12,
                            )
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [

                            Text(
                              word.word,
                              style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold),
                            ),

                            Text(
                              word.pos,
                              style: const TextStyle(
                                  color: Colors.grey),
                            ),

                            const SizedBox(height: 24),

                            if (showMeaning) ...[
                              Text(
                                word.meaning,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Example:",
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold),
                              ),
                              Text(
                                word.example,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontStyle:
                                        FontStyle.italic),
                              )
                            ] else
                              const Text(
                                "Tap to reveal meaning",
                                style:
                                    TextStyle(color: Colors.blue),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Idiom Popup
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
                        const SizedBox(height: 10),
                        Text(
                          idiom.idiom,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
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
                        )
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
