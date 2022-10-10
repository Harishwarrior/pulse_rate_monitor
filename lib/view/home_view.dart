import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wakelock/wakelock.dart';
import 'setting.dart';
import 'utils/chart.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class HomePageView extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  final List<SensorValue> _data = <SensorValue>[]; // array to store the values
  CameraController _controller;
  final double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  final int _fs = 30; // sampling frequency (fps)
  final int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage _image; // store the last camera image
  double _avg; // store the average value during calculation
  DateTime _now; // store the now Datetime
  Timer _timer; // timer for image processing

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      .addListener(() {
        setState(() {
          _iconScale = 1.0 + _animationController.value * 0.4;
        });
      });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
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
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Settings();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      (_bpm.toString()),
                      style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'BPM',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
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
              SizedBox(
                height: 20,
              ),
              Text(
                'Place index finger on the camera',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2296CB).withOpacity(0.9),
                        Color(0xFF2296CB).withOpacity(0.8),
                        Color(0xFF2296CB).withOpacity(0.7),
                        Color(0xFF2296CB).withOpacity(0.6),
                        Color(0xFF2296CB).withOpacity(0.5),
                        Color(0xFF2296CB).withOpacity(0.4),
                        Color(0xFF2296CB).withOpacity(0.3),
                        Color(0xFF2296CB).withOpacity(0.2),
                        Color(0xFF2296CB).withOpacity(0.1),
                        Color(0xFF2296CB).withOpacity(0.0),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.0),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Chart(_data),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
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
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
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
                        Text(
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
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
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
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++) {
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
    }
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      setState(() {
        _toggled = true;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller.setFlashMode(FlashMode.torch);
      });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (exception) {
      debugPrint(exception);
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, _avg));
    });
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      for (var value in _values) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      }
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
          if (minbpm == 0) {
            minbpm = this._bpm;
          }
          if (this._bpm > maxbpm) maxbpm = this._bpm;
          if (this._bpm < minbpm) minbpm = this._bpm;
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }
}
