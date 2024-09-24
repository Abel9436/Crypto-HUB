import 'package:cryptohub/API/fetch_coin_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CandleStickChartPage extends StatefulWidget {
  @override
  String coniname;
  CandleStickChartPage({super.key, required this.coniname});
  _CandleStickChartPageState createState() => _CandleStickChartPageState();
}

class _CandleStickChartPageState extends State<CandleStickChartPage> {
  late Future<List<CandleData>> _candleData;

  @override
  void initState() {
    super.initState();
    // Fetch data for the coin for the last 7 days
    _candleData = fetchCandlestickData(widget.coniname.toLowerCase(), 7);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("${widget.coniname.toUpperCase()}/USDT"),
      ),
      body: FutureBuilder<List<CandleData>>(
        future: _candleData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Lottie.asset(
                    height: height / 5, 'assets/lottie/loader.json'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SfCartesianChart(
              backgroundColor: Colors
                  .black, // Set the background color to black like Binance
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              primaryYAxis: NumericAxis(
                opposedPosition:
                    true, // Move the Y-axis to the right like Binance
                majorGridLines: const MajorGridLines(color: Colors.grey),
                axisLine: const AxisLine(width: 0),
                numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
              ),
              series: <CandleSeries>[
                CandleSeries<CandleData, DateTime>(
                  dataSource: snapshot.data!,
                  xValueMapper: (CandleData data, _) => data.time,
                  lowValueMapper: (CandleData data, _) => data.low,
                  highValueMapper: (CandleData data, _) => data.high,
                  openValueMapper: (CandleData data, _) => data.open,
                  closeValueMapper: (CandleData data, _) => data.close,
                  enableSolidCandles: true, // Binance-style filled candlesticks
                  bullColor: Colors.green, // Color for rising candles
                  bearColor: Colors.red, // Color for falling candles
                ),
              ],

              // Enable interactive features
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                zoomMode: ZoomMode.xy,
              ),
              trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipSettings: InteractiveTooltip(
                    format:
                        'point.x : point.high \nOpen: point.open \nClose: point.close',
                    color: Colors.grey[800],
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  lineType: TrackballLineType.vertical),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: Colors.grey[800],
                textStyle: const TextStyle(color: Colors.white),
                header: '',
                format:
                    'point.x : point.high \nOpen: point.open \nClose: point.close',
              ),
              crosshairBehavior: CrosshairBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
              ),
            );
          }
        },
      ),
    );
  }
}

class CandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.time, this.open, this.high, this.low, this.close);
}
