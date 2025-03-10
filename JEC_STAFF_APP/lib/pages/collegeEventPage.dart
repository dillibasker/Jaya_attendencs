import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CollegeEventPage extends StatefulWidget {
  const CollegeEventPage({super.key});

  @override
  _CollegeEventPageState createState() => _CollegeEventPageState();
}

class _CollegeEventPageState extends State<CollegeEventPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, String>> _events = [];

  void _addEvent() {
    TextEditingController nameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController placeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Event"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Event Name"),
              _buildTextField(dateController, "Date (DD/MM/YYYY)"),
              _buildTextField(timeController, "Time (HH:MM AM/PM)"),
              _buildTextField(placeController, "Place"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _events.add({
                    "name": nameController.text,
                    "date": dateController.text,
                    "time": timeController.text,
                    "place": placeController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Events"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendar(),
              const SizedBox(height: 16),
              _buildEventCards(), // Directly displaying events as cards
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: _addEvent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.blue.shade700,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.purple.shade700,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: const TextStyle(color: Colors.red),
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
      ),
    );
  }

  Widget _buildEventCards() {
    return _events.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child:
                  Text("No events added yet", style: TextStyle(fontSize: 16)),
            ),
          )
        : Column(
            children: _events.map((event) {
              return _EventTile(
                event["name"]!,
                event["date"]!,
                event["time"]!,
                event["place"]!,
              );
            }).toList(),
          );
  }
}

class _EventTile extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final String place;
  const _EventTile(this.name, this.date, this.time, this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
          ),
          child: const Icon(Icons.event, color: Colors.white),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text("$date | $time | $place",
            style: const TextStyle(color: Colors.blueGrey)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
          ),
          child: const Text(
            "View",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
