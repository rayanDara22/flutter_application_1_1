import 'package:flutter/material.dart';

class GradingScreen extends StatefulWidget {
  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  List<String> students = [
    'Dalia Ako',
    'Dya Jalal',
    'Rayan Dara',
  ];

  List<String> grades = List.filled(5, 'Grades');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 170, 49, 41),
        title: Center(
          child: Text(
            'Grading Screen',
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
            children: <Widget>[
              ListTile(
                title: Text(
                  students[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: grades[index],
                  onChanged: (String? newValue) {
                    _updateGrade(index, newValue!);
                  },
                  items: <String>[
                    'Grades',
                    '40',
                    '50',
                    '60',
                    '70',
                    '80',
                    '90',
                    '100'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.7,
              ), // Divider between each student
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 170, 49, 41),
        onPressed: () {
          _showConfirmationDialog(context);
        },
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }

  void _updateGrade(int index, String newValue) {
    setState(() {
      grades[index] = newValue;
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Grades'),
          content:
              Text('Are you sure you want to submit the grades to students?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _submitGrades(); // Call a function to submit grades
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitGrades() {
    // Logic to submit grades
    print('Grades submitted: $grades');
  }
}

void main() {
  runApp(MaterialApp(
    home: GradingScreen(),
  ));
}
