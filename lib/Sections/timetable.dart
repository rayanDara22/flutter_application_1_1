import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<TimetableDay> timetables = [
    TimetableDay(
      day: 'Sunday',
      timetable: [
        '8:00 AM - 10:00 AM: Class 1',
        '10:30 AM - 12:30 PM: Class 2',
      ],
    ),
    TimetableDay(
      day: 'Monday',
      timetable: [
        '9:00 AM - 11:00 AM: Class 4',
        '11:30 AM - 1:30 PM: Class 5',
      ],
    ),
    TimetableDay(
      day: 'Tuesday',
      timetable: [
        '8:30 AM - 10:30 AM: Class 7',
        '11:00 AM - 1:00 PM: Class 8',
      ],
    ),
    TimetableDay(
      day: 'Wednesday',
      timetable: [
        '10:00 AM - 12:00 PM: Class 10',
        '12:30 PM - 2:30 PM: Class 11',
      ],
    ),
    TimetableDay(
      day: 'Thursday',
      timetable: [
        '9:30 AM - 11:30 AM: Class 13',
        '12:00 PM - 2:00 PM: Class 14',
      ],
    ),
  ];

  void addTimetable(String day, List<String> timetable) {
    setState(() {
      timetables.add(TimetableDay(day: day, timetable: timetable));
    });
  }

  void deleteTimetable(int index) {
    setState(() {
      timetables.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 247, 213),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 204, 60),
        title: Center(
          child: Text(
            'Timetable',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 244, 204, 60),
        onPressed: () {
          // Navigate to add timetable screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTimetableScreen(addTimetable: addTimetable),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: timetables.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(timetables[index].day),
            onDismissed: (direction) {
              // Delete timetable entry
              deleteTimetable(index);
            },
            child: timetables[index],
          );
        },
      ),
    );
  }
}

class TimetableDay extends StatelessWidget {
  final String day;
  final List<String> timetable;

  const TimetableDay({
    Key? key,
    required this.day,
    required this.timetable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit screen and pass timetable details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTimetableScreen(
                              day: day,
                              timetable: timetable,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Deletion"),
                              content: Text(
                                  "Are you sure you want to delete this timetable day?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    // Delete the timetable entry
                                    // You can call the delete function from TimetableScreen here
                                    // Example: Provider.of<TimetableProvider>(context, listen: false).deleteTimetable(index);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: timetable.map((slot) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  slot,
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class AddTimetableScreen extends StatefulWidget {
  final Function(String, List<String>) addTimetable;

  AddTimetableScreen({required this.addTimetable});

  @override
  _AddTimetableScreenState createState() => _AddTimetableScreenState();
}

class _AddTimetableScreenState extends State<AddTimetableScreen> {
  String day = '';
  List<String> timetable = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 128, 60, 237),
        title: Center(
            child: Text(
          'Add Timetable',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  day = value;
                });
              },
              decoration: InputDecoration(labelText: 'Day'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  timetable = value.split(', ');
                });
              },
              decoration: InputDecoration(labelText: 'Timetable'),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.addTimetable(day, timetable);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 173, 33,
                      243), // Set the background color for the button
                ),
                child: Text(
                  'Add new Timetable',
                  style: TextStyle(
                    color: Colors.white, // Set text color
                    fontWeight: FontWeight.bold, // Set text style
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTimetableScreen extends StatefulWidget {
  String day;
  List<String> timetable;

  EditTimetableScreen({required this.day, required this.timetable});

  @override
  _EditTimetableScreenState createState() => _EditTimetableScreenState();
}

class _EditTimetableScreenState extends State<EditTimetableScreen> {
  late TextEditingController dayController;
  late TextEditingController timetableController;

  @override
  void initState() {
    super.initState();
    dayController = TextEditingController(text: widget.day);
    timetableController =
        TextEditingController(text: widget.timetable.join(', '));
  }

  @override
  void dispose() {
    dayController.dispose();
    timetableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 156, 146),
        title: Center(
          child: Text(
            'Edit Timetable',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: dayController,
              onChanged: (value) {
                setState(() {
                  widget.day = value;
                });
              },
              decoration: InputDecoration(labelText: 'Day'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: timetableController,
              onChanged: (value) {
                setState(() {
                  widget.timetable = value.split(', ');
                });
              },
              decoration: InputDecoration(labelText: 'Timetable'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Update timetable with edited details
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 20, 114,
                    108), // Set the background color for the button
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 20, 114,
                    108), // Set the background color for the button
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimetableScreen(),
  ));
}
