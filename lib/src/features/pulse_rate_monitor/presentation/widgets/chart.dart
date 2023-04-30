import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// This widget shows the cardiogram like chart
class Chart extends StatelessWidget {
  /// Creates [Chart]
  const Chart(
    this._data, {
    super.key,
  });
  final List<SensorValue> _data;

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<SensorValue, DateTime>(
          id: 'Values',
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
          domainFn: (SensorValue values, _) => values.time,
          measureFn: (SensorValue values, _) => values.value,
          data: _data,
        )
      ],
      animate: false,
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
        renderSpec: charts.NoneRenderSpec(),
      ),
      domainAxis: const charts.DateTimeAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }
}

/// Model class for sensor value
class SensorValue {
  /// Creates [SensorValue]
  const SensorValue(this.time, this.value);

  /// Time in which the sensor reading is recorded
  final DateTime time;

  /// Value of the sensor reading
  final double value;
}
