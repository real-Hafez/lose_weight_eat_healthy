import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class Timepacker extends StatefulWidget {
  const Timepacker({super.key});

  @override
  _TimepackerState createState() => _TimepackerState();
}

class _TimepackerState extends State<Timepacker> {
  TimeOfDay? _wakeUpTime;
  TimeOfDay? _sleepTime;
  bool _is24HourFormat = false; // Track format selection

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Wake-up Time: ${_wakeUpTime?.format(context) ?? 'None'}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Sleep Time: ${_sleepTime?.format(context) ?? 'None'}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await showTimePickerDialog(
                context: context,
                initialTime: _wakeUpTime ?? TimeOfDay.now(),
              );
            },
            child: const Text('Pick Wake-up Time'),
          ),
          ElevatedButton(
            onPressed: () async {
              await showTimePickerDialog(
                context: context,
                initialTime: _sleepTime ?? TimeOfDay.now(),
              );
            },
            child: const Text('Pick Sleep Time'),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('24-Hour Format'),
            value: _is24HourFormat,
            onChanged: (bool value) {
              setState(() {
                _is24HourFormat = value;
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> showTimePickerDialog({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    final TimePicker picker = TimePicker(
      initTime: PickedTime(h: initialTime.hour, m: initialTime.minute),
      endTime: PickedTime(h: 23, m: 59), // You can adjust end time if needed
      isInitHandlerSelectable: true,
      isEndHandlerSelectable: true,
      onSelectionChange: (start, end, isDisableRange) {
        print(
            'onSelectionChange => init : ${start.h}:${start.m}, end : ${end.h}:${end.m}, isDisableRange: $isDisableRange');
      },
      onSelectionEnd: (start, end, isDisableRange) {
        print(
            'onSelectionEnd => init : ${start.h}:${start.m}, end : ${end.h}:${end.m}, isDisableRange: $isDisableRange');
        setState(() {
          if (context.widget.key == const Key('wakeUpTimePicker')) {
            _wakeUpTime = TimeOfDay(hour: start.h, minute: start.m);
          } else if (context.widget.key == const Key('sleepTimePicker')) {
            _sleepTime = TimeOfDay(hour: start.h, minute: start.m);
          }
        });
      },
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Time'),
        content: SizedBox(
          height: 300,
          child: picker,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
