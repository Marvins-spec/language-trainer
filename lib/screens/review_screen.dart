import 'package:flutter/material.dart';
import '../engine/memory_engine.dart';
import 'practice_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() =>
      _ReviewScreenState();
}

class _ReviewScreenState
    extends State<ReviewScreen> {

  final MemoryEngine engine = MemoryEngine();
  bool loading = true;

  @override
  void initState() {
    super.initState();

    engine.loadWords().then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final reviewList = engine.reviewWords;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Text("${reviewList.length} words ready"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: reviewList.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PracticeScreen(
                                reviewWords: reviewList,
                              ),
                        ),
                      );
                    },
              child: const Text("Start Review"),
            ),
          ],
        ),
      ),
    );
  }
}
