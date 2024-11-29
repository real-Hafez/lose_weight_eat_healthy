import 'package:flutter/material.dart';

class ActivityLevelPage extends StatefulWidget {
  @override
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const ActivityLevelPage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});

  _ActivityLevelPageState createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends State<ActivityLevelPage> {
  String? selectedActivityLevel;

  final List<Map<String, String>> activityLevels = [
    {
      "title": "Sedentary",
      "description":
          "Little or no exercise. Example: Office work, sitting most of the day.",
      "calculation": "BMR x 1.2",
    },
    {
      "title": "Lightly Active",
      "description":
          "Light exercise/sports 1-3 days/week. Example: Walking, light gym sessions.",
      "calculation": "BMR x 1.375",
    },
    {
      "title": "Moderately Active",
      "description":
          "Moderate exercise/sports 3-5 days/week. Example: Gym 3-5 days/week.",
      "calculation": "BMR x 1.55",
    },
    {
      "title": "Very Active",
      "description":
          "Hard exercise/sports 6-7 days/week. Example: Intensive gym training.",
      "calculation": "BMR x 1.725",
    },
    {
      "title": "Extra Active",
      "description":
          "Very hard exercise or physical job. Example: Athlete, 2x daily training.",
      "calculation": "BMR x 1.9",
    },
  ];

  void selectActivityLevel(String title) {
    setState(() {
      selectedActivityLevel = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Activity Level'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What is your activity level?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activityLevels.length,
                itemBuilder: (context, index) {
                  final level = activityLevels[index];
                  final isSelected = selectedActivityLevel == level["title"];

                  return GestureDetector(
                    onTap: () => selectActivityLevel(level["title"]!),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle,
                              color: isSelected ? Colors.blue : Colors.grey,
                              size: 32,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level["title"]!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    level["description"]!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    level["calculation"]!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: selectedActivityLevel != null
                  ? () {
                      // Handle continue action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You selected: $selectedActivityLevel'),
                        ),
                      );
                    }
                  : null,
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
