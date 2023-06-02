import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:speedometer/speedometer.dart';
String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<StepCount> _stepCountStream;
  String _steps = '?';
  int _stepsStartValue = 0;

  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int start = 0;
  int end = 60;

  int counter = 0;

  PublishSubject<double> eventObservable = PublishSubject();


  @override
  void initState() {
    super.initState();
    initPlatformState();
    const oneSec = const Duration(seconds: 1);
    var rng = Random();
    Timer.periodic(oneSec,
        (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
  }
// 1200 startVal
// 1201 value = startVal - _steps = 1
  
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _steps,
                  style: TextStyle(fontSize: 60),
                ),
              ),
              // Divider(
              //   height: 100,
              //   thickness: 0,
              //   color: Colors.white,
              // ),
              SpeedOMeter(
                  start: start,
                  end: end,
                  highlightStart: (_lowerValue / end),
                  highlightEnd: (_upperValue / end),
                 themeData: ThemeData.dark(),
                  eventObservable: this.eventObservable),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';


// void main() {
//   runApp(MyApp());
// }
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   double _accelerometerX = 0.0;
//   double _accelerometerY = 0.0;
//   double _accelerometerZ = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       setState(() {
//         _accelerometerX = event.x;
//         _accelerometerY = event.y;
//         _accelerometerZ = event.z;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Hareket Hızı:'),
//               Text('${_accelerometerX.toStringAsFixed(2)}, '
//                   '${_accelerometerY.toStringAsFixed(2)}, '
//                   '${_accelerometerZ.toStringAsFixed(2)}'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:developer';

// import 'package:flutter/widgets.dart';

// class LifecycleWatcher extends StatefulWidget {
//   const LifecycleWatcher({super.key});

//   @override
//   State<LifecycleWatcher> createState() => _LifecycleWatcherState();
// }

// class _LifecycleWatcherState extends State<LifecycleWatcher>
//     with WidgetsBindingObserver {
//   AppLifecycleState? _lastLifecycleState;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     setState(() {
//       _lastLifecycleState = state;
//       if(_lastLifecycleState == AppLifecycleState.detached)
//       {
//         log('detached');
//       }
//       else if(_lastLifecycleState == AppLifecycleState.resumed)
//       {
//         log('resumed');
//       }
//       else if(_lastLifecycleState == AppLifecycleState.inactive)
//       {
//         log('inactive');
//       }
//       else if(_lastLifecycleState == AppLifecycleState.paused)
//       {
//         log('paused');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_lastLifecycleState == null) {
//       return const Text(
//         'This widget has not observed any lifecycle changes.',
//         textDirection: TextDirection.ltr,
//       );
//     }

//     return Text(
//       'The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
//       textDirection: TextDirection.ltr,
//     );
//   }
// }

// void main() {
//   runApp(const Center(child: LifecycleWatcher()));
// }