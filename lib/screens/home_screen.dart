// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker_app/util/habit_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Overall habit sumary
  List habitList = [
    // [ habitName, habitStarted, timeSpent (sec), timeGoal (sec) ]
    ['Exercise', false, 0, 1],
    ['Read', false, 0, 10],
    ['Meditate', false, 0, 15],
    ['Code', false, 0, 20],
  ];

  void _havbitStarted(int index) {
    // Note what the start time is
    var startTime = DateTime.now();
    print(startTime);

    // Include the time already elapsed
    int elapsedTime = habitList[index][2];

    // Habit started or stopped
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      // Keep time going!
      Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(
            () {
              // Check when the user has stopped the timer
              if (!habitList[index][1]) {
                timer.cancel();
              }
              // Caculate the time elapsed by comparing current time and start time
              var currentTime = DateTime.now();
              habitList[index][2] = elapsedTime +
                  currentTime.second -
                  startTime.second +
                  60 * (currentTime.minute - startTime.minute) +
                  60 * 60 * (currentTime.hour - startTime.hour);
            },
          );
        },
      );
    }
  }

  void _settingsOpened(int index) {
    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // ignore: prefer_interpolation_to_compose_strings
            title: Text('Settings for ' + habitList[index][0]),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Consistency is key.'),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.grey[900],
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habitName: habitList[index][0],
            habitStarted: habitList[index][1],
            timeSpent: habitList[index][2],
            timeGoal: habitList[index][3],
            onTap: () {
              _havbitStarted(index);
            },
            settingsTapped: () {
              _settingsOpened(index);
            },
          );
        },
      ),
    );
  }
}
