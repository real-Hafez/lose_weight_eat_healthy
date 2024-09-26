import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/History.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/water_calendar_widget.dart';

class Water extends StatelessWidget {
  const Water({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WaterBloc()..add(LoadInitialData()),
      child: Scaffold(
        body: BlocListener<WaterBloc, WaterState>(
          listener: (context, state) {
            if (state is WaterLoading) {
              // Show loading spinner instantly
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading...')),
              );
            } else if (state is WaterLoaded) {
              // Remove any existing SnackBar when data is loaded
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } else if (state is WaterError) {
              // Show an error message if there is a failure
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<WaterBloc, WaterState>(
            builder: (context, state) {
              if (state is WaterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WaterLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const WaterIntakeWidget(),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: water_calendar_widget(
                          onDaySelected: (selectedDay) {
                            context
                                .read<WaterBloc>()
                                .add(LoadIntakeHistory(selectedDay));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: History(
                          intakeHistory: state.intakeHistory,
                          savedUnit: state.unit,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is WaterError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
