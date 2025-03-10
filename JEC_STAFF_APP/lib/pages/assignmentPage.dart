import 'package:flutter/material.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  DateTime? _selectedDeadline;

  final List<Map<String, dynamic>> _assignments = [];

  void _pickDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _publishAssignment() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDeadline == null ||
        _marksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }

    setState(() {
      _assignments.add({
        "title": _titleController.text,
        "description": _descriptionController.text,
        "deadline": _selectedDeadline,
        "marks": _marksController.text,
      });
      _titleController.clear();
      _descriptionController.clear();
      _marksController.clear();
      _selectedDeadline = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignments"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Assignment",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Assignment Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Assignment Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Assignment Description
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Select Deadline Button with Gradient
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDeadline == null
                        ? "Select Deadline"
                        : "Deadline: ${_selectedDeadline!.toLocal()}"
                            .split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                InkWell(
                  onTap: () => _pickDeadline(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Pick Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Marks Field
            TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Total Marks",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Publish Assignment Button with Gradient
            SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: _publishAssignment,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: const Text(
                      "Publish Assignment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Display Published Assignments
            const Text(
              "Published Assignments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _assignments.isEmpty
                ? const Center(child: Text("No assignments published yet."))
                : Column(
                    children: _assignments.map((assignment) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assignment["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                assignment["description"],
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Deadline: ${assignment["deadline"].toLocal()}"
                                        .split(' ')[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Marks: ${assignment["marks"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
