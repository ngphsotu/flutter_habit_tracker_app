import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.onTap,
    required this.settingsTapped,
    required this.timeSpent,
    required this.timeGoal,
    required this.habitStarted,
  });

  // Convert seconds into min:sec -> ex: 62 seconds = 1:02 min
  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);

    // If secs is a 1 digit number place a 0 infront of it
    if (secs.length == 1) {
      secs = '0$secs';
    }

    // If mins is a 1 digit number
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }
    return '$mins:$secs';
  }

  // Caculate progress percentage
  double percentCompleted() {
    return timeSpent / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        // Progress circle
                        CircularPercentIndicator(
                          radius: 30,
                          percent:
                              percentCompleted() < 1 ? percentCompleted() : 1,
                          progressColor: percentCompleted() > 0.5
                              ? (percentCompleted() > 0.75
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.red,
                        ),
                        // Play - Pause button
                        Center(
                          child: Icon(
                            habitStarted ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Habit name
                    Text(
                      habitName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Progress
                    Text(
                      '${formatToMinSec(timeSpent)} / $timeGoal =  ${(percentCompleted() * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: settingsTapped,
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
