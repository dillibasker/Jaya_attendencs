import 'package:flutter/material.dart';

typedef ImageCallback = void Function();

class ClassTimetablePage extends StatefulWidget {
  @override
  _ClassTimetablePageState createState() => _ClassTimetablePageState();
}

class _ClassTimetablePageState extends State<ClassTimetablePage> {
  String? _imageTitle;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedDepartment;

  void _deleteImage() {
    setState(() {
      _imageTitle = null;
      _selectedClass = null;
      _selectedSection = null;
      _selectedDepartment = null;
    });
  }

  void _openUploadDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController classController = TextEditingController();
    TextEditingController sectionController = TextEditingController();
    TextEditingController departmentController = TextEditingController();
    bool imageSelected = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Upload Class Timetable"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(titleController, "Timetable Name"),
                    _buildTextField(classController, "Class"),
                    _buildTextField(sectionController, "Section"),
                    _buildTextField(departmentController, "Department"),
                    SizedBox(height: 10),
                    imageSelected
                        ? Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: Icon(Icons.image,
                                size: 50, color: Colors.grey[600]),
                          )
                        : Text("No Image Selected"),
                    SizedBox(height: 10),
                    _buildGradientButton(
                      text: "Select Image",
                      icon: Icons.image,
                      colors: [Colors.blue, Colors.purple],
                      onPressed: () {
                        setStateDialog(() {
                          imageSelected = true;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildGradientButton(
                      text: "Cancel",
                      icon: Icons.cancel,
                      colors: [Colors.red.shade400, Colors.red.shade700],
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildGradientButton(
                      text: "Upload",
                      icon: Icons.upload_file,
                      colors: [Colors.green.shade400, Colors.green.shade700],
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            classController.text.isEmpty ||
                            sectionController.text.isEmpty ||
                            departmentController.text.isEmpty ||
                            !imageSelected) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Please fill all fields and select an image")),
                          );
                          return;
                        }
                        setState(() {
                          _imageTitle = titleController.text;
                          _selectedClass = classController.text;
                          _selectedSection = sectionController.text;
                          _selectedDepartment = departmentController.text;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
        title: Text("Class Timetable"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: _imageTitle == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No timetable uploaded", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  _buildGradientButton(
                    text: "Upload Timetable",
                    icon: Icons.upload_file,
                    colors: [Colors.blue, Colors.purple],
                    onPressed: _openUploadDialog,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_imageTitle ?? "Class Timetable",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Class: $_selectedClass"),
                  Text("Section: $_selectedSection"),
                  Text("Department: $_selectedDepartment"),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.grey[300],
                    child:
                        Icon(Icons.image, size: 100, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  _buildGradientButton(
                    text: "Delete Timetable",
                    icon: Icons.delete,
                    colors: [Colors.red.shade400, Colors.red.shade700],
                    onPressed: _deleteImage,
                  ),
                ],
              ),
      ),
    );
  }
}
