import 'package:flutter/material.dart';

class StudentRemarkPage extends StatefulWidget {
  final String className;

  const StudentRemarkPage({super.key, required this.className});

  @override
  _StudentRemarkPageState createState() => _StudentRemarkPageState();
}

class _StudentRemarkPageState extends State<StudentRemarkPage> {
  final List<Map<String, dynamic>> students = [
    {"name": "Allwyn", "id": "1108231040XX", "remarks": []},
    {"name": "Archana", "id": "1108231041XX", "remarks": []},
    {"name": "Dilli", "id": "1108231042XX", "remarks": []},
    {"name": "Harish", "id": "1108231043XX", "remarks": []},
    {"name": "Jai", "id": "1108231044XX", "remarks": []},
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

  void _addRemark(int index) {
    TextEditingController remarkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Remark for ${filteredStudents[index]["name"]}"),
          content: TextField(
            controller: remarkController,
            decoration: const InputDecoration(hintText: "Enter Remark"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String remark = remarkController.text.trim();
                if (remark.isNotEmpty) {
                  setState(() {
                    students
                        .firstWhere((student) =>
                            student["name"] ==
                            filteredStudents[index]["name"])["remarks"]
                        .add(remark);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Remark Added Successfully!")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _confirmRemoveRemark(int studentIndex, int remarkIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this remark?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  students
                      .firstWhere((student) =>
                          student["name"] ==
                          filteredStudents[studentIndex]["name"])["remarks"]
                      .removeAt(remarkIndex);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Remark Removed!")),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Remarks - ${widget.className}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
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
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filteredStudents[index]["name"],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("ID: ${filteredStudents[index]["id"]}"),
                        const SizedBox(height: 8),
                        if (filteredStudents[index]["remarks"].isNotEmpty) ...[
                          const Text(
                            "Remarks:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              filteredStudents[index]["remarks"].length,
                              (remarkIndex) => GestureDetector(
                                onLongPress: () =>
                                    _confirmRemoveRemark(index, remarkIndex),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: const LinearGradient(
                                      colors: [Colors.red, Colors.redAccent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Text(
                                    filteredStudents[index]["remarks"]
                                        [remarkIndex],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => _addRemark(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Text(
                                "Add Remark",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
