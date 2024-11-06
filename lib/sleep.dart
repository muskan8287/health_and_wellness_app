import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';  // Syncfusion chart import
import 'package:shared_preferences/shared_preferences.dart'; // Add SharedPreferences

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  List<DateTime> _sleepTimes = [];

  @override
  void initState() {
    super.initState();
    _loadSleepTimes();
  }

  // Load sleep times from local storage (SharedPreferences)
  Future<void> _loadSleepTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sleepTimesStrings = prefs.getStringList('sleepTimes') ?? [];

    setState(() {
      _sleepTimes = sleepTimesStrings
          .map((sleepTimeString) => DateTime.parse(sleepTimeString))
          .toList();
    });
  }

  // Save sleep times to local storage (SharedPreferences)
  Future<void> _saveSleepTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> sleepTimesStrings =
    _sleepTimes.map((sleepTime) => sleepTime.toIso8601String()).toList();
    await prefs.setStringList('sleepTimes', sleepTimesStrings);
  }

  Future<void> _addSleepTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime currentTime = DateTime.now();
      DateTime sleepTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        _sleepTimes.add(sleepTime);
      });

      // Save to local storage
      await _saveSleepTimes();
    }
  }

  Widget _buildSleepChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity, // Match parent width
        height: 200.0, // Adjust the height as needed
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(
            title: AxisTitle(text: 'Index'),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Sleep Hour'),
          ),
          series: <LineSeries<DateTime, double>>[
            LineSeries<DateTime, double>(
              dataSource: _sleepTimes,  // Your list of sleep times
              xValueMapper: (DateTime time, int index) => index.toDouble(),  // X-axis: Index
              yValueMapper: (DateTime time, _) => time.hour.toDouble(),  // Y-axis: Sleep hour
              markerSettings: MarkerSettings(isVisible: true),  // Optionally show markers
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sleep Analysis',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 45.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/sleep.jpg', // Placeholder image path
                    height: 300.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _sleepTimes.isEmpty
                  ? Center(
                child: Text('No sleep times recorded.'),
              )
                  : _buildSleepChart(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSleepTime,
        tooltip: 'Add Sleep Time',
        child: Icon(Icons.add),
      ),
    );
  }
}
