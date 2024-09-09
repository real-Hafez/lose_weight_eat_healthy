import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

class Timepacker extends StatefulWidget {
  const Timepacker({super.key});

  @override
  _TimepackerState createState() => _TimepackerState();
}

class _TimepackerState extends State<Timepacker> {
  TimeOfDay? _wakeUpTime;
  TimeOfDay? _sleepTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wake-up Time: ${_wakeUpTime?.format(context) ?? 'None'}'),
          Text('Sleep Time: ${_sleepTime?.format(context) ?? 'None'}'),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDateTime = await showBoardDateTimePicker(
                context: context,
                pickerType: DateTimePickerType.time,
              );
              if (pickedDateTime != null) {
                setState(() {
                  _wakeUpTime = TimeOfDay(
                      hour: pickedDateTime.hour, minute: pickedDateTime.minute);
                });
              }
            },
            child: const Text('Pick Wake-up Time'),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDateTime = await showBoardDateTimePicker(
                context: context,
                pickerType: DateTimePickerType.time,
              );
              if (pickedDateTime != null) {
                setState(() {
                  _sleepTime = TimeOfDay(
                      hour: pickedDateTime.hour, minute: pickedDateTime.minute);
                });
              }
            },
            child: const Text('Pick Sleep Time'),
          ),
        ],
      ),
    );
  }
}
