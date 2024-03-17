import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<String> students = [
    'Dalia Ako',
    'Dya Jalal',
    'Rayan Dara',
  ];
  List<bool?> attendance = List.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 20, 20),
        title: Center(
          child: Text(
            'Attendance',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  students[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: attendance[index],
                      onChanged: (value) {
                        setState(() {
                          attendance[index] = value;
                        });
                      },
                    ),
                    Text(
                      'Present',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Radio<bool>(
                      value: false,
                      groupValue: attendance[index],
                      onChanged: (value) {
                        setState(() {
                          attendance[index] = value;
                        });
                      },
                    ),
                    Text(
                      'Absent',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.7,
              ), // Add a divider between each student
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 167, 20, 20),
        onPressed: () {
          // Save attendance or perform any other action
          print('Attendance: $attendance');
          _showAttendanceDialog();
        },
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Attendance Saved'),
          content: Text('Attendance has been successfully saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AttendanceScreen(),
  ));
}
