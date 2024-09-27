import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  WaterBloc() : super(WaterInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<AddWaterIntake>(_onAddWaterIntake);
    on<UpdateGoalStatus>(_onUpdateGoalStatus);
    on<ResetWaterIntake>(_onResetWaterIntake);
    on<LoadIntakeHistory>(_onLoadIntakeHistory);
    _listenToWidgetUpdates();
  }
  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');

  final Map<String, List<double>> defaultCardAmounts = {
    'mL': [100, 200, 400, 500],
    'L': [0.1, 0.2, 0.4, 0.5],
    'US oz': [3.38, 6.76, 13.53, 16.91],
  };

  Future<void> _onLoadInitialData(
      LoadInitialData event, Emitter<WaterState> emit) async {
    emit(WaterLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Load the unit
      String unit = prefs.getString('water_unit') ?? 'mL';
      List<double> cardAmounts =
          defaultCardAmounts[unit] ?? defaultCardAmounts['mL']!;

      // Load custom card amounts if available
      List<double> customCardAmounts = [];
      for (int i = 0; i < 4; i++) {
        double? savedAmount = prefs.getDouble('card_$i');
        customCardAmounts.add(savedAmount ?? defaultCardAmounts[unit]![i]);
      }

      final String? lastResetDateStr = prefs.getString('last_reset_date');
      final DateTime now = DateTime.now();
      DateTime? lastResetDate;
      if (lastResetDateStr != null) {
        lastResetDate = DateTime.parse(lastResetDateStr);
      }

      if (lastResetDate == null || !_isSameDay(lastResetDate, now)) {
        // Before resetting, check if previous day's goal was not reached and mark it as false
        if (lastResetDate != null && !_isSameDay(lastResetDate, now)) {
          final yesterdayKey =
              "${lastResetDate.year}-${lastResetDate.month}-${lastResetDate.day}";
          final goalCompletionStatus =
              prefs.getStringList('goal_status_dates') ?? [];

          bool isGoalReached = goalCompletionStatus
              .any((date) => date.startsWith('$yesterdayKey:true'));
          if (!isGoalReached) {
            goalCompletionStatus
                .removeWhere((date) => date.startsWith(yesterdayKey));
            goalCompletionStatus.add('$yesterdayKey:false'); // Mark as X
            await prefs.setStringList(
                'goal_status_dates', goalCompletionStatus);
          }
        }
        add(ResetWaterIntake());
      }

      // Load other data (water needed, intake, etc.)
      double waterNeeded = prefs.getDouble('water_needed') ?? 6000.0;
      double currentIntake = prefs.getDouble('water_drunk') ?? 0.0;

      List<String> goalStatusDates =
          prefs.getStringList('goal_status_dates') ?? [];
      Map<DateTime, bool> goalCompletionStatus = {};
      for (String dateStr in goalStatusDates) {
        final parts = dateStr.split(":");
        final dateParts = parts[0].split("-");
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);
        final status = parts[1] == 'true';
        goalCompletionStatus[DateTime(year, month, day)] = status;
      }

      final String todayKey =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      List<String> historyList = prefs.getStringList(todayKey) ?? [];
      List<Map<String, dynamic>> intakeHistory = historyList.map((record) {
        final parts = record.split(":");
        final amount = double.parse(parts[0]);
        final dateTime = DateTime.parse(parts[1]);
        return {'date': dateTime, 'amount': amount};
      }).toList();

      emit(WaterLoaded(
        currentIntake: currentIntake,
        waterNeeded: waterNeeded,
        unit: unit,
        cardAmounts: cardAmounts,
        goalCompletionStatus: goalCompletionStatus,
        intakeHistory: intakeHistory,
      ));
    } catch (e) {
      emit(const WaterError('Failed to load preferences'));
    }
  }

  Future<void> _listenToWidgetUpdates() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "updateAppState") {
        final currentState = state;
        double intakeAmount = 0;

        if (currentState is WaterLoaded) {
          if (currentState.unit == 'mL') {
            intakeAmount = 300.0;
          } else if (currentState.unit == 'L') {
            intakeAmount = 0.3;
          } else if (currentState.unit == 'US oz') {
            intakeAmount = 10.14;
          }

          // Trigger event to update water intake in the app
          add(AddWaterIntake(intakeAmount));
        }
      }
    });
  }

  Future<void> _onAddWaterIntake(
      AddWaterIntake event, Emitter<WaterState> emit) async {
    final currentState = state;
    if (currentState is WaterLoaded) {
      double newIntake = (currentState.currentIntake + event.amount)
          .clamp(0, currentState.waterNeeded);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('water_drunk', newIntake);

      final today = DateTime.now();
      final todayKey = "${today.year}-${today.month}-${today.day}";
      List<String> historyList = prefs.getStringList(todayKey) ?? [];
      historyList.add('${event.amount}:${today.toIso8601String()}');
      await prefs.setStringList(todayKey, historyList);

      // Update goal status
      bool goalReached = newIntake >= currentState.waterNeeded;
      await _updateGoalStatus(prefs, today, goalReached);

      Map<DateTime, bool?> updatedGoalCompletionStatus =
          Map.from(currentState.goalCompletionStatus);
      updatedGoalCompletionStatus[
          DateTime(today.year, today.month, today.day)] = goalReached;

      List<Map<String, dynamic>> updatedHistory =
          _loadIntakeHistory(prefs, today);

      emit(WaterLoaded(
        currentIntake: newIntake,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        cardAmounts: const [],
        goalCompletionStatus: updatedGoalCompletionStatus,
        intakeHistory: updatedHistory,
      ));

      // Send update to widget
      await _updateWidget(
          newIntake, currentState.waterNeeded, currentState.unit);
    }
  }

  Future<void> _updateWidget(
      double waterDrunk, double waterNeeded, String unit) async {
    try {
      await platform.invokeMethod('updateWidget', {
        'water': waterNeeded,
        'water_drunk': waterDrunk,
        'unit': unit,
      });
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  Future<void> _updateGoalStatus(
      SharedPreferences prefs, DateTime date, bool goalReached) async {
    List<String> goalStatusDates =
        prefs.getStringList('goal_status_dates') ?? [];
    final formattedDate = "${date.year}-${date.month}-${date.day}";

    goalStatusDates.removeWhere((entry) => entry.startsWith(formattedDate));
    goalStatusDates.add('$formattedDate:$goalReached');

    await prefs.setStringList('goal_status_dates', goalStatusDates);
  }

  Future<void> _onUpdateGoalStatus(
      UpdateGoalStatus event, Emitter<WaterState> emit) async {
    final currentState = state;
    if (currentState is WaterLoaded) {
      Map<DateTime, bool> updatedGoalCompletionStatus =
          Map.from(currentState.goalCompletionStatus)
            ..[DateTime.now()] = event.goalReached;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> goalStatusDates =
          prefs.getStringList('goal_status_dates') ?? [];
      final formattedDate =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      if (event.goalReached) {
        goalStatusDates.removeWhere((date) => date.startsWith(formattedDate));
        goalStatusDates.add('$formattedDate:true');
      } else {
        goalStatusDates.removeWhere((date) => date.startsWith(formattedDate));
        goalStatusDates.add('$formattedDate:false');
      }

      await prefs.setStringList('goal_status_dates', goalStatusDates);

      emit(WaterLoaded(
        currentIntake: currentState.currentIntake,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        cardAmounts: const [],
        goalCompletionStatus: updatedGoalCompletionStatus,
        intakeHistory: currentState.intakeHistory,
      ));
    }
  }

  // Ensure the daily reset logic is triggered correctly.
  Future<void> _onResetWaterIntake(
      ResetWaterIntake event, Emitter<WaterState> emit) async {
    final currentState = state;
    if (currentState is WaterLoaded) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('water_drunk', 0.0);
      await prefs.setString(
          'last_reset_date', DateTime.now().toIso8601String());

      emit(WaterLoaded(
        currentIntake: 0.0,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        goalCompletionStatus: currentState.goalCompletionStatus,
        intakeHistory: const [],
        cardAmounts: const [],
      ));
    }
  }

  Future<void> _onLoadIntakeHistory(
      LoadIntakeHistory event, Emitter<WaterState> emit) async {
    final currentState = state;
    if (currentState is WaterLoaded) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> selectedDayHistory =
          _loadIntakeHistory(prefs, event.selectedDay);

      emit(WaterLoaded(
        currentIntake: currentState.currentIntake,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        goalCompletionStatus: currentState.goalCompletionStatus,
        intakeHistory: selectedDayHistory,
        cardAmounts: const [],
      ));
    }
  }

  List<Map<String, dynamic>> _loadIntakeHistory(
      SharedPreferences prefs, DateTime date) {
    final dateKey = "${date.year}-${date.month}-${date.day}";
    List<String>? historyList = prefs.getStringList(dateKey);
    return historyList?.map((record) {
          final parts = record.split(":");
          final amount = double.parse(parts[0]);
          final dateTime = DateTime.parse(parts[1]);
          return {'date': dateTime, 'amount': amount};
        }).toList() ??
        [];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
