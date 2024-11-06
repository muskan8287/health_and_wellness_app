import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Appointment>> _events = {};
  List<Appointment> _selectedAppointments = [];

  @override
  void initState() {
    super.initState();
    _selectedAppointments = _events[_selectedDay] ?? [];
  }

  // Adds an appointment to the selected day
  void _addAppointment(DateTime selectedDate, String doctorName) {
    setState(() {
      if (_events[selectedDate] == null) {
        _events[selectedDate] = [];
      }
      _events[selectedDate]?.add(Appointment(dateTime: selectedDate, doctorName: doctorName));
      _selectedAppointments = _events[_selectedDay] ?? [];
    });

    // Show a confirmation message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Confirmed'),
          content: Text('Your appointment with Dr. $doctorName on ${DateFormat('MMMM d, y').format(selectedDate)} has been confirmed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Shows the dialog to add a new appointment
  void _showAddAppointmentDialog() {
    DateTime selectedDate = _selectedDay;
    String doctorName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add a New Appointment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select Date:'),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blueAccent),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('MMMM d, y').format(selectedDate),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Enter Doctor\'s Name:'),
                  TextField(
                    onChanged: (value) {
                      doctorName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Doctor\'s Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (doctorName.isNotEmpty) {
                      _addAppointment(selectedDate, doctorName);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Appointments for ${DateFormat('MMMM d, y').format(_selectedDay)}:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                _selectedAppointments.isEmpty
                    ? Text('No appointments for this day', style: TextStyle(color: Colors.white))
                    : Column(
                  children: _selectedAppointments.map((appointment) {
                    return ListTile(
                      title: Text('Dr. ${appointment.doctorName}', style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TableCalendar(
                  calendarFormat: _calendarFormat,
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2050),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedAppointments = _events[selectedDay] ?? [];
                    });
                  },
                  eventLoader: (day) {
                    return _events[day] ?? [];
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(color: Colors.purpleAccent, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    todayTextStyle: TextStyle(color: Colors.black),
                    selectedTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showAddAppointmentDialog,
                  child: Text('Add Appointment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Appointment {
  final DateTime dateTime;
  final String doctorName;

  Appointment({required this.dateTime, required this.doctorName});
}
