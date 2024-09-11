import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_cubit.dart'; // Import for DateFormat

class Timepacker extends StatefulWidget {
  final Function(TimeOfDay) onWakeUpTimeSelected;
  final Function(TimeOfDay) onSleepTimeSelected;

  const Timepacker({
    super.key,
    required this.onWakeUpTimeSelected,
    required this.onSleepTimeSelected,
  });

  @override
  _TimepackerState createState() => _TimepackerState();
}

class _TimepackerState extends State<Timepacker> {
  TimeOfDay? _wakeUpTime;
  TimeOfDay? _sleepTime;
  bool _is24HourFormat = false;
  static const int _recommendedSleepHours = 8;

  @override
  void initState() {
    super.initState();
    _initializeTimeFormat();
  }

  void _initializeTimeFormat() {
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
          widget.onWakeUpTimeSelected(pickedTime);
          _suggestSleepTime(pickedTime);
        } else {
          _sleepTime = pickedTime;
          widget.onSleepTimeSelected(pickedTime);
        }
      });
    }
  }

  void _suggestSleepTime(TimeOfDay wakeUpTime) {
    final int wakeUpHour = wakeUpTime.hour;
    final int wakeUpMinute = wakeUpTime.minute;

    final int sleepHour = (wakeUpHour - _recommendedSleepHours) % 24;
    final int sleepMinute = wakeUpMinute;

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
        ],
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isWakeUpTime) {
    return ElevatedButton(
      onPressed: () => _selectTime(context, isWakeUpTime),
      child: Text(
        isWakeUpTime
            ? (_wakeUpTime != null ? _wakeUpTime!.format(context) : 'Select')
            : (_sleepTime != null ? _sleepTime!.format(context) : 'Select'),
      ),
    );
  }
}
