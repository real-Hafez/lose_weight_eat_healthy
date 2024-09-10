import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_cubit.dart'; // Import for DateFormat

class Timepacker extends StatefulWidget {
  const Timepacker({super.key});

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
          _suggestSleepTime(pickedTime);
          context.read<WaterCubit>().selectWakeUpTime(true);
        } else {
          _sleepTime = pickedTime;
          context.read<WaterCubit>().selectSleepTime(true);
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
