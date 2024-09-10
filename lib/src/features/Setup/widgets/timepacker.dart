import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timepacker extends StatefulWidget {
  const Timepacker({super.key});

  @override
  _TimepackerState createState() => _TimepackerState();
}

class _TimepackerState extends State<Timepacker> {
  TimeOfDay? _wakeUpTime;
  TimeOfDay? _sleepTime;
  bool _is24HourFormat = false;
  static const int _recommendedSleepHours = 8; // Recommended sleep duration

  @override
  void initState() {
    super.initState();
    _initializeTimeFormat();
  }

  void _initializeTimeFormat() {
    // Know if the device uses 24 or 12 hour format
    final String currentTime = DateFormat.jm().format(DateTime.now());
    setState(() {
      _is24HourFormat = !currentTime.contains(RegExp(r'[APMapm]'));
    });
  }

  Future<void> _selectTime(BuildContext context, bool isWakeUpTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isWakeUpTime
          ? _wakeUpTime ?? TimeOfDay.now()
          : _sleepTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: _is24HourFormat,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isWakeUpTime) {
          _wakeUpTime = pickedTime;
          // Automatically suggest sleep time based on wake-up time
          _suggestSleepTime(pickedTime);
        } else {
          _sleepTime = pickedTime;
        }
      });
    }
  }

  void _suggestSleepTime(TimeOfDay wakeUpTime) {
    // Calculate sleep time (subtract _recommendedSleepHours from wakeUpTime)
    final int wakeUpHour = wakeUpTime.hour;
    final int wakeUpMinute = wakeUpTime.minute;

    // Calculate the suggested sleep time (subtract 8 hours)
    final int sleepHour = (wakeUpHour - _recommendedSleepHours) % 24;
    final int sleepMinute = wakeUpMinute; // Assuming the same minute as wake-up

    setState(() {
      _sleepTime = TimeOfDay(hour: sleepHour, minute: sleepMinute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Wake-up Time:',
            style: TextStyle(fontSize: 18),
          ),
          _buildTimePicker(context, true),
          const SizedBox(height: 16),
          if (_wakeUpTime != null)
            Column(
              children: [
                const Text(
                  'Sleep Time:',
                  style: TextStyle(fontSize: 18),
                ),
                _buildTimePicker(context, false),
              ],
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isWakeUpTime) {
    final TimeOfDay? selectedTime = isWakeUpTime ? _wakeUpTime : _sleepTime;

    return GestureDetector(
      onTap: () => _selectTime(context, isWakeUpTime),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          selectedTime != null
              ? selectedTime.format(context)
              : isWakeUpTime
                  ? 'Select Wake-up Time'
                  : 'Select Sleep Time',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
