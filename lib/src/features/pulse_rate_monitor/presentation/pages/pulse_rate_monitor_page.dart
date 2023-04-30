import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pulse_rate_monitor/src/features/pulse_rate_monitor/presentation/widgets/chart.dart';
import 'package:pulse_rate_monitor/src/features/settings/presentation/pages/settings_page.dart';
import 'package:wakelock/wakelock.dart';

/// This widget is the main page of the app contains graph
/// and core functionality of the app
class PulseRateMonitorPage extends StatefulWidget {
  /// Creates [PulseRateMonitorPage]
  const PulseRateMonitorPage({super.key});

  @override
  State<PulseRateMonitorPage> createState() {
    return _PulseRateMonitorPageState();
  }
}

class _PulseRateMonitorPageState extends State<PulseRateMonitorPage>
    with SingleTickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  final List<SensorValue> _data = <SensorValue>[]; // array to store the values
  CameraController? _controller;
  final double _alpha = 0.3; // factor for the mean value
  late AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  final int _fs = 30; // sampling frequency (fps)
  final int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage? _image; // store the last camera image
  double? _avg; // store the average value during calculation
  DateTime? _now; // store the now Datetime
  Timer? _timer; // timer for image processing

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addListener(() {
      setState(() {
        _iconScale = 1.0 + _animationController.value * 0.4;
      });
    });
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    _toggled = false;
    await _disposeController();
    await Wakelock.disable();
    _animationController
      ..stop()
      ..dispose();
    super.dispose();
  }

  int maxbpm = 0;
  int minbpm = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await _untoggle();
              if (mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (context) {
                      return const SettingsPage();
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              CircularPercentIndicator(
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Transform.scale(
                        scale: _iconScale,
                        child: IconButton(
                          icon: Icon(
                            _toggled ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: Colors.red,
                          iconSize: 60,
                          onPressed: () {
                            if (_toggled) {
                              _untoggle();
                            } else {
                              _toggle();
                            }
                          },
                        ),
                      ),
                    ),
                    Text(
                      _bpm.toString(),
                      style: const TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'BPM',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                radius: 150,
                lineWidth: 4,
                arcBackgroundColor: Colors.grey,
                arcType: ArcType.FULL,
                progressColor: Theme.of(context).primaryColor,
                percent:
                    (_bpm.toDouble() / 200) > 1 ? 1 : (_bpm.toDouble() / 200),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Place index finger on the camera\nand tap the heart icon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF2296CB).withOpacity(0.9),
                        const Color(0xFF2296CB).withOpacity(0.8),
                        const Color(0xFF2296CB).withOpacity(0.7),
                        const Color(0xFF2296CB).withOpacity(0.6),
                        const Color(0xFF2296CB).withOpacity(0.5),
                        const Color(0xFF2296CB).withOpacity(0.4),
                        const Color(0xFF2296CB).withOpacity(0.3),
                        const Color(0xFF2296CB).withOpacity(0.2),
                        const Color(0xFF2296CB).withOpacity(0.1),
                        const Color(0xFF2296CB).withOpacity(0),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.1),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.2),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.3),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.5),
                      ],
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Chart(_data),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MIN',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              minbpm.toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'BPM',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MAX',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              maxbpm.toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'BPM',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < _windowLen; i++) {
      _data.insert(
        0,
        SensorValue(
          DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs),
          128,
        ),
      );
    }
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController.repeat(reverse: true);
      setState(() {
        _toggled = true;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  Future<void> _untoggle() async {
    setState(() {
      _toggled = false;
    });
    await _disposeController();
    await Wakelock.disable();
    _animationController
      ..stop()
      ..value = 0.0;
  }

  Future<void> _disposeController() async {
    await _controller?.dispose();
  }

  Future<void> _initController() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras.first, ResolutionPreset.low);
      await _controller?.initialize();
      await Future<void>.delayed(const Duration(milliseconds: 100))
          .then((onValue) {
        _controller?.setFlashMode(FlashMode.torch);
      });
      await _controller?.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) {
          _scanImage(_image!);
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes!.reduce((value, element) => value + element) /
            image.planes.first.bytes!.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      if (_now != null && _avg != null) {
        _data.add(SensorValue(_now!, _avg!));
      }
    });
  }

  Future<void> _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is
    // very rudimentary
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it
    // executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> values;
    double avg;
    int n;
    double m;
    double threshold;
    double bpm;
    int counter;
    int previous;
    while (_toggled) {
      values = List.from(_data); // create a copy of the current data array
      avg = 0;
      n = values.length;
      m = 0;
      for (final value in values) {
        avg += value.value / n;
        if (value.value > m) m = value.value;
      }
      threshold = (m + avg) / 2;
      bpm = 0;
      counter = 0;
      previous = 0;
      for (var i = 1; i < n; i++) {
        if (values[i - 1].value < threshold && values[i].value > threshold) {
          if (previous != 0) {
            counter++;
            bpm +=
                60 * 1000 / (values[i].time.millisecondsSinceEpoch - previous);
          }
          previous = values[i].time.millisecondsSinceEpoch;
        }
      }
      if (counter > 0) {
        bpm = bpm / counter;
        setState(() {
          _bpm = ((1 - _alpha) * _bpm + _alpha * bpm).toInt();
          if (minbpm == 0) {
            minbpm = _bpm;
          }
          if (_bpm > maxbpm) maxbpm = _bpm;
          if (_bpm < minbpm) minbpm = _bpm;
        });
      }
      await Future<void>.delayed(
        Duration(
          milliseconds: 1000 * _windowLen ~/ _fs,
        ),
      ); // wait for a new set of _data values
    }
  }
}
