import 'package:flutter/material.dart';

class MedicationAlarmScreen extends StatefulWidget {
  const MedicationAlarmScreen({Key? key}) : super(key: key);

  @override
  _MedicationAlarmScreenState createState() => _MedicationAlarmScreenState();
}

class _MedicationAlarmScreenState extends State<MedicationAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  String _medicationName = '';
  String _frequency = 'Once a day';
  List<dynamic> medicationAlarms = [];
  List<TimeOfDay> _medicationTimes = [
    TimeOfDay.now()
  ]; // Initialize with current time

  @override
  void initState() {
    super.initState();
    // Retrieve medication alarms from local storage (if needed)
    _retrieveMedicationAlarms();
  }

  Future<void> _retrieveMedicationAlarms() async {
    // Simulate retrieving alarms from a local source (in this case, just an empty list)
    setState(() {
      medicationAlarms = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pill Tracker',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        backgroundColor: const Color(0xFF1a2543),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back arrow color to white
        ),
      ),
      backgroundColor: const Color(0xFF1a2543),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
              child: Image.asset(
                'assets/pills.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showAddMedicationModal(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0, // Remove button elevation
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add), // Plus icon
                    SizedBox(width: 8), // Add some space between the icon and text
                    Text('Add Medication'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: medicationAlarms.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> medicationAlarm = medicationAlarms[index];
                var medicationTimes = medicationAlarm['medicationTimes'];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: const Color.fromARGB(255, 13, 14, 15)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.medication),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  medicationAlarm['medicationName'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteMedication(index);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Times',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: medicationTimes != null
                            ? (medicationTimes as List)
                            .map<Widget>((time) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 95, 103, 110),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            time,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ))
                            .toList()
                            : [],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Medication Name',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a medication name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _medicationName = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter medication name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Frequency',
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: _frequency,
                    onChanged: (value) {
                      setState(() {
                        _frequency = value!;
                        if (_frequency == 'Twice a day') {
                          _medicationTimes = [
                            const TimeOfDay(hour: 8, minute: 0),
                            const TimeOfDay(hour: 20, minute: 0),
                          ];
                        } else {
                          _medicationTimes = [TimeOfDay.now()];
                        }
                      });
                    },
                    items: <String>['Once a day', 'Twice a day']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Medication Times',
                    style: TextStyle(fontSize: 18),
                  ),
                  Column(
                    children: _medicationTimes.map((time) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              child: Text(
                                '${time.hour}:${time.minute}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: time,
                                );
                                if (picked != null) {
                                  setState(() {
                                    _medicationTimes[_medicationTimes
                                        .indexOf(time)] = picked;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          List<String> medicationTimes = _medicationTimes
                              .map((time) => '${time.hour}:${time.minute}')
                              .toList();

                          Map<String, dynamic> medicationAlarmData = {
                            'medicationName': _medicationName,
                            'medicationTimes': medicationTimes,
                            'frequency': _frequency,
                          };

                          setState(() {
                            medicationAlarms.add(medicationAlarmData);
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _deleteMedication(int index) {
    setState(() {
      medicationAlarms.removeAt(index);
    });
  }
}
