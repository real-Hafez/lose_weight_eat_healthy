import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitPouringHourGlass(
        strokeWidth: 1,
        color: Colors.orange,
        size: 120.0,
      
      ),
    );
  }
}
