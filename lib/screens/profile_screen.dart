import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  final String userName;
  final Function(String) onNameChanged;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.userName,
    required this.onNameChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool reminderOn = false;

  void showChangeNameDialog() {
    TextEditingController controller =
        TextEditingController(text: widget.userName);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Change Name"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter your name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onNameChanged(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget buildCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ ใช้ theme
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : Colors.black12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ ใช้ theme
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              Text(
                "Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 20),

              // ===== USER CARD =====
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text("Keep learning every day 🔥"),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: showChangeNameDialog,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Learning Stats",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              buildCard("🔥 Words Learned", "23"),
              buildCard("⭐ Total XP", "120"),
              buildCard("🧠 Accuracy", "78%"),

              const SizedBox(height: 30),

              Text(
                "Settings",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("🌙 Dark Mode"),
                    Switch(
                      value: widget.isDarkMode,
                      onChanged: widget.onThemeChanged,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("🔔 Reminder"),
                    Switch(
                      value: reminderOn,
                      onChanged: (v) {
                        setState(() {
                          reminderOn = v;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}