import 'package:bloc/bloc.dart';
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
  }

  Future<void> _onLoadInitialData(
      LoadInitialData event, Emitter<WaterState> emit) async {
    emit(WaterLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      double waterNeeded = prefs.getDouble('water_needed') ?? 6000.0;
      String unit = prefs.getString('water_unit') ?? 'mL';
      double currentIntake = prefs.getDouble('water_drunk') ?? 0.0;

      // Load goal completion status
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

      // Load intake history for the current day
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
        goalCompletionStatus: goalCompletionStatus,
        intakeHistory: intakeHistory,
      ));
    } catch (e) {
      emit(const WaterError('Failed to load preferences'));
    }
  }

  Future<void> _onAddWaterIntake(
      AddWaterIntake event, Emitter<WaterState> emit) async {
    final currentState = state;
    if (currentState is WaterLoaded) {
      double newIntake = (currentState.currentIntake + event.amount)
          .clamp(0, currentState.waterNeeded);
      List<Map<String, dynamic>> updatedHistory =
          List.from(currentState.intakeHistory)
            ..add({
              'date': DateTime.now(),
              'amount': event.amount,
            });

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String todayKey =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      List<String>? historyList = prefs.getStringList(todayKey) ?? [];
      historyList.add('${event.amount}:${DateTime.now().toIso8601String()}');
      await prefs.setStringList(todayKey, historyList);
      await prefs.setDouble('water_drunk', newIntake);

      emit(WaterLoaded(
        currentIntake: newIntake,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        goalCompletionStatus: currentState.goalCompletionStatus,
        intakeHistory: updatedHistory,
      ));
    }
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
      goalStatusDates.add('$formattedDate:${event.goalReached}');
      await prefs.setStringList('goal_status_dates', goalStatusDates);

      emit(WaterLoaded(
        currentIntake: currentState.currentIntake,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        goalCompletionStatus: updatedGoalCompletionStatus,
        intakeHistory: currentState.intakeHistory,
      ));
    }
  }

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
      ));
    }
  }

  Future<void> _onLoadIntakeHistory(
      LoadIntakeHistory event, Emitter<WaterState> emit) async {
    final currentState = state;
    if (currentState is WaterLoaded) {
      final String selectedDayKey =
          "${event.selectedDay.year}-${event.selectedDay.month}-${event.selectedDay.day}";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? historyList = prefs.getStringList(selectedDayKey);
      List<Map<String, dynamic>> selectedDayHistory =
          historyList?.map((record) {
                final parts = record.split(":");
                final amount = double.parse(parts[0]);
                final dateTime = DateTime.parse(parts[1]);
                return {'date': dateTime, 'amount': amount};
              }).toList() ??
              [];

      emit(WaterLoaded(
        currentIntake: currentState.currentIntake,
        waterNeeded: currentState.waterNeeded,
        unit: currentState.unit,
        goalCompletionStatus: currentState.goalCompletionStatus,
        intakeHistory: selectedDayHistory,
      ));
    }
  }
}
