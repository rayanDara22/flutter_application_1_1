import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Taskk(),
  ));
}

class Taskk extends StatefulWidget {
  const Taskk({Key? key}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Taskk> {
  DateTime? _selectedDate;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 245, 243),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 107, 132, 100),
        title: Center(
          child: Text(
            ' Task  ',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create a Task',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _titleController,
                onChanged: (_) {
                  setState(() {}); // Update UI when title changes
                },
                decoration: InputDecoration(
                  labelText: 'Write a title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              // Section for selecting deadline
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deadline',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context); // Open date picker
                          },
                          child: AbsorbPointer(
                            // AbsorbPointer prevents the text field from being edited directly
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Select Deadline',
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () {
                                _selectDate(context); // Open date picker
                              },
                              controller: _selectedDate == null
                                  ? TextEditingController()
                                  : TextEditingController(
                                      text: '${_selectedDate!.toLocal()}'
                                          .split(' ')[0],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    color: Colors.black,
                    onPressed: () {
                      _selectDate(context); // Open date picker
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('Description',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                onChanged: (_) {
                  setState(() {}); // Update UI when description changes
                },
                decoration: InputDecoration(
                  labelText: 'Write a description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 50),
              // Send button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(
                          context); // Show confirmation dialog
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 119, 150, 115), // Change button color to green
                    ),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToNextPage(context); // Navigate to next page
                    },
                    child: Text(
                      'Show task',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 119, 150, 115), // Change button color to blue
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await _showCustomDatePicker(context);
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate; // Update selected date
      });
      print('Selected date: $_selectedDate');
    }
  }

  // Function to show custom date picker
  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    DateTime? pickedDate = _selectedDate ?? DateTime.now();
    pickedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(
                  255, 127, 162, 128), // Change the primary color to green
            ),
            dialogBackgroundColor: Colors.white, // Set dialog background color
          ),
          child: child!,
        );
      },
    );
    return pickedDate;
  }

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to send?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Color.fromARGB(255, 87, 112, 88)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 87, 112, 88)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Function to navigate to the next page
  void _navigateToNextPage(BuildContext context) {
    // Extract title, description, and deadline from text controllers
    String title = _titleController.text;
    String description = _descriptionController.text;
    String deadline = _selectedDate != null
        ? _selectedDate!.toString().split(' ')[0]
        : "Not selected";

    // Navigate to the next page and pass the details as arguments
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(
          title: title,
          description: description,
          deadline: deadline,
        ),
      ),
    );
  }
}

// Next page to display the task details
class TaskDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String deadline;

  const TaskDetailsPage({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 104, 141, 97),
        title: Center(
            child: Text(
          'Tasks',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              'Deadline: $deadline',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              'Description: $description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Divider(
            //   thickness: 1,
            //   color: Colors.black,
            // )
          ],
        ),
      ),
    );
  }
}
