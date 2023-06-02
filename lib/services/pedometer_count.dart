import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pedometer/pedometer.dart';

class PedometerCount extends StatefulWidget {
  const PedometerCount({super.key});

  @override
  State<PedometerCount> createState() => _PedometerCountState();
}

class _PedometerCountState extends State<PedometerCount> {
  late Stream<StepCount> _stepCountStream;
  String _steps = '?';
  int _stepsStartValue = 0;
  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      if(_stepsStartValue == 0)
      {
        _stepsStartValue = event.steps;
      }
      _steps = (event.steps - _stepsStartValue).toString();
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;    
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}