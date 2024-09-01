import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class SixthOnboardingPage extends StatefulWidget {
  const SixthOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _SixthOnboardingPageState createState() => _SixthOnboardingPageState();
}

class _SixthOnboardingPageState extends State<SixthOnboardingPage> {
  final Set<String> _selectedOptions = {}; // Track selected options

  @override
  void initState() {
    super.initState();
    // Set default selected options
    _selectedOptions.add('Training');
    _selectedOptions.add('Food Health');
  }

  @override
  Widget build(BuildContext context) {
    // Call onAnimationFinished after some animation or delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAnimationFinished();
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProgressIndicatorWidget(value: 0.8),
          const SizedBox(height: 20),
          const TitleWidget(title: 'What do you care about in the app?'),
          const SizedBox(height: 20),
          OptionsWidget(
            selectedOptions: _selectedOptions,
            onOptionToggle: _toggleOption,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option); // Unselect the option
      } else {
        _selectedOptions.add(option); // Select the option
      }
    });
  }
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({
    super.key,
    required this.selectedOptions,
    required this.onOptionToggle,
  });

  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionButton(
          label: 'Training',
          icon: Icons.fitness_center,
          isSelected: selectedOptions.contains('Training'),
          onToggle: () => onOptionToggle('Training'),
        ),
        const SizedBox(height: 10),
        OptionButton(
          label: 'Food Health',
          icon: Icons.restaurant,
          isSelected: selectedOptions.contains('Food Health'),
          onToggle: () => onOptionToggle('Food Health'),
        ),
        const SizedBox(height: 10),
        OptionButton(
          label: 'Water Reminder',
          icon: Icons.local_drink,
          isSelected: selectedOptions.contains('Water Reminder'),
          onToggle: () => onOptionToggle('Water Reminder'),
        ),
        NextButton(onPressed: () {}, collectionName: 'useofapp')
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onToggle;

  const OptionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onToggle,
      icon: Icon(
        icon,
        size: 24,
        color: isSelected
            ? Colors.green
            : Colors.white, // Change icon color based on selection
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.green
              : Colors.white, // Change text color based on selection
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: isSelected
            ? Colors.grey[300]
            : Theme.of(context)
                .primaryColor, // Change button color when selected
      ),
    );
  }
}
