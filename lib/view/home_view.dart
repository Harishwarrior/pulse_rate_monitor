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
  List<SensorValue> _data = <SensorValue>[]; // array to store the values
  CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
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
      ..addListener(() {
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(55),
                      bottomLeft: Radius.circular(55)
                  ),
                  color: Colors.white24),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          color: Colors.black,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(55),
                                bottomLeft: Radius.circular(55)
                            ),),
                        child: _toggled ? Chart(_data)
                            : Image.asset("assets/beat.jpg",
                          width: MediaQuery.of(context).size.width,)
                    ),
                    Expanded(child: SizedBox(height: 5,)),
                    Text(
                      "Estimated BPM",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 35),
            Transform.scale(
                scale: _iconScale,
                child: GestureDetector(
                  onTap: () {
                    if (_toggled) {
                      _untoggle();
                    } else {
                      _toggle();
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(0xffcd0000),
                    radius: 60,
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: _toggled ? Colors.transparent : Colors.black,
                      backgroundImage: _toggled ? AssetImage(
                        "assets/beat.jpg",) : null,
                      child: !_toggled ? Text("Start",style: TextStyle(color: Colors.white,fontSize: 25,)) : null,
                    ),
                  ),
                )
            ),
            SizedBox(height: 35),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(55),
                          topRight: Radius.circular(55)
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: <Widget>[
                            _controller != null && _toggled
                                ? AspectRatio(
                                    aspectRatio:
                                        _controller.value.aspectRatio,
                                    child: CameraPreview(_controller),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(12),
                                    alignment: Alignment.center,
                                    color: Colors.white24,
                                  ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined,size: 60,color: _toggled
                                      ? Colors.white
                                      : Colors.grey),
                                  Text(
                                    _toggled
                                        ? " Cover both the camera and the flash with your finger ."
                                        : " Camera feed will display here .",
                                    style: TextStyle(
                                        backgroundColor: _toggled
                                            ? Colors.white
                                            : Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
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
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
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
