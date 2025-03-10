import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  final String session;

  const AttendancePage({super.key, required this.session});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Map<String, dynamic>> students = [
    {"name": "Allwyn", "id": "1108231040XX", "present": false},
    {"name": "Ajay", "id": "1108231041XX", "present": false},
    {"name": "Dilli", "id": "1108231042XX", "present": false},
    {"name": "Harish", "id": "1108231043XX", "present": false},
    {"name": "Jai", "id": "1108231044XX", "present": false},
  ];

  List<Map<String, dynamic>> filteredStudents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  void _searchStudent(String query) {
    setState(() {
      filteredStudents = students
          .where((student) =>
              student["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleAttendance(int index) {
    setState(() {
      filteredStudents[index]["present"] = !filteredStudents[index]["present"];
    });
  }

  void submitAttendance() {
    List<Map<String, dynamic>> attendanceData = filteredStudents.map((student) {
      return {
        "id": student["id"],
        "name": student["name"],
        "status": student["present"] ? "Present" : "Absent",
      };
    }).toList();

    print("Attendance for ${widget.session} Submitted: $attendanceData");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.session} Attendance Submitted!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.session} Attendance")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: _searchStudent,
              decoration: InputDecoration(
                hintText: "Search Student...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredStudents[index]["name"]),
                  subtitle: Text("ID: ${filteredStudents[index]["id"]}"),
                  trailing: Checkbox(
                    value: filteredStudents[index]["present"],
                    onChanged: (value) => toggleAttendance(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: submitAttendance,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Submit Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
