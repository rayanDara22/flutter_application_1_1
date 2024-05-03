import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GradingScreen extends StatefulWidget {
  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, String> grades = {}; // Changed to a map
  String selectedGroup = '';
  late String teacherId;

  @override
  void initState() {
    super.initState();
    fetchTeacherId();
  }

  Future<void> fetchTeacherId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        teacherId = user.uid;
      });
    } else {
      // Handle the case when the user is not authenticated
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 69, 143, 218),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('groups')
            .where('teacherId', isEqualTo: teacherId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Widget> groupWidgets = [];
          snapshot.data!.docs.forEach((doc) {
            String groupName = doc['groupName'];
            groupWidgets.add(
              ListTile(
                title: Text(groupName),
                onTap: () {
                  setState(() {
                    selectedGroup = groupName;
                    grades.clear(); // Clear grades map
                  });
                  _showEmailsDialog(groupName, doc['studentEmails']);
                },
              ),
            );
          });

          return ListView(
            children: groupWidgets,
          );
        },
      ),
    );
  }

  void _showEmailsDialog(String groupName, List<dynamic> emails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Select Grade for Emails in $groupName'),
              content: Container(
                // Wrap content in Container for background color
                color: Colors.white, // Set background color of dialog content
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var email in emails)
                      ListTile(
                        title: Text(email.toString()),
                        trailing: DropdownButton<String>(
                          value: grades[email] ?? 'Grades',
                          onChanged: (String? newValue) {
                            setState(() {
                              grades[email] = newValue!;
                            });
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
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Set Cancel button text color
                  ),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _submitGrades(groupName);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.blue, // Set Submit button text color
                  ),
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitGrades(String groupName) {
    // Iterate through the grades map to submit each email's grade
    grades.forEach((email, grade) {
      if (grade != 'Grades') {
        _firestore.collection('grades').add({
          'groupName': groupName,
          'email': email,
          'grade': grade,
        }).then((value) {
          print('Grade submitted: $grade for $email in $groupName');
        }).catchError((error) {
          print('Error submitting grade for $email in $groupName: $error');
        });
      }
    });
  }
}
