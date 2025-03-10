import 'package:flutter/material.dart';
import 'package:flutter_project_app/pages/studentremarkpage.dart';

class RemarkPage extends StatelessWidget {
  final List<String> classes = [
    "CSE II SEC A",
    "CSE II SEC B",
    "CSE III SEC A",
    "CSE III SEC B",
    "CSE IV SEC A",
    "CSE IV SEC B",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Class for Remark"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: classes.map((className) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  className,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color to contrast the gradient
                  ),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentRemarkPage(className: className),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
