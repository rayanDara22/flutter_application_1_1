import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Taskk extends StatefulWidget {
  const Taskk({Key? key}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Taskk> {
  DateTime? _selectedDate;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _selectedGroupName; // Variable to store the selected group name
  List<String> _groupNames = []; // List to store group names from Firestore

  @override
  void initState() {
    super.initState();
    _fetchGroupNames(); // Fetch group names when the widget initializes
  }

  Future<void> _saveTaskDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String teacherId = user.uid;

        // Save task details to Firestore with teacher ID and selected group name
        await FirebaseFirestore.instance.collection('tasks').add({
          'teacherId': teacherId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'deadline': _selectedDate != null
              ? _selectedDate!.toLocal().toString().split(' ')[0]
              : null,
          'groupName': _selectedGroupName,
          'status': 'Ongoing', // Set the initial status as 'Ongoing'
        });

        // Clear input fields after saving
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedDate = null;
          _selectedGroupName = null;
        });

        // Show a success message or navigate to another page if needed
      }
    } catch (e) {
      print('Error saving task details: $e');
      // Handle error
    }
  }

  Future<void> _fetchGroupNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      List<String> groups = [];
      querySnapshot.docs.forEach((doc) {
        groups.add(doc['groupName']);
      });

      setState(() {
        _groupNames = groups; // Update group names list
      });
    } catch (e) {
      print('Error fetching group names: $e');
    }
  }

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
              // Dropdown menu for selecting group name
              DropdownButtonFormField<String>(
                value: _selectedGroupName,
                decoration: InputDecoration(
                  labelText: 'Select Group',
                  border: OutlineInputBorder(),
                ),
                items: _groupNames.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGroupName = newValue; // Update selected group name
                  });
                },
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
                      _saveTaskDetails(); // Call _saveTaskDetails method
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 119, 150, 115),
                    ),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {
                      String teacherId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      _navigateToNextPage(context, teacherId);
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
  void _navigateToNextPage(BuildContext context, String teacherId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListPage(teacherId: teacherId),
      ),
    );
  }
}

class TaskListPage extends StatelessWidget {
  final String teacherId;

  const TaskListPage({Key? key, required this.teacherId}) : super(key: key);

  Future<void> _markTaskAsDone(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'status': 'Done'});
    } catch (e) {
      print('Error marking task as done: $e');
      // Handle error....
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 227, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 168, 3, 197),
        title: Center(
            child: Text(
          'Task List',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('teacherId', isEqualTo: teacherId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var task = snapshot.data.docs[index];
                String taskId = task.id; // Get the task ID
                String status = task['status'] ?? ''; // Get the task status
                return ListTile(
                  title: Text(task['title'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${task['description'] ?? ''}'),
                      Text('Deadline: ${task['deadline'] ?? ''}'),
                      Text('Status: $status'), // Display the task status
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status !=
                          'Done') // Show the button only if status is not 'Done'
                        ElevatedButton(
                          onPressed: () {
                            _markTaskAsDone(taskId); // Mark the task as 'Done'
                          },
                          child: Text('Done'),
                        ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching tasks'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
