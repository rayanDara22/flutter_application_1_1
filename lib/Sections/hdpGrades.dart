import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GradingScreen2 extends StatefulWidget {
  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, String> grades = {}; // Map to store grades
  Map<String, String> currentGrades =
      {}; // Map to store current grades for display

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
        backgroundColor: Colors.amber,
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
        stream: _firestore.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              String groupName = doc['groupName'];
              List<dynamic> studentEmails = doc['studentEmails'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(groupName),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showEmailsDialog(groupName, studentEmails);
                          },
                          child: Text('Add Grades'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _viewGrades(groupName);
                          },
                          child: Text('View Grades'),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showEmailsDialog(String groupName, List<dynamic> emails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<Map<String, String>>(
          future: _fetchGradesForEmails(emails),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            grades = snapshot.data!;
            currentGrades =
                Map.from(grades); // Initialize currentGrades with grades

            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AlertDialog(
                  title: Text('Enter Grades for $groupName'),
                  content: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var email in emails)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(email.toString()),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    initialValue: grades[email] ?? '',
                                    decoration: InputDecoration(
                                      hintText: 'Grade',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        grades[email] = value;
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                    'Current: ${currentGrades[email]}'), // Display current grade separately
                              ],
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
                        backgroundColor:
                            Colors.red, // Set Cancel button text color
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
      },
    );
  }

  Future<Map<String, String>> _fetchGradesForEmails(
      List<dynamic> emails) async {
    Map<String, String> fetchedGrades = {};

    for (var email in emails) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('grades')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        fetchedGrades[email] = doc['grade'];
      } else {
        fetchedGrades[email] = '';
      }
    }

    return fetchedGrades;
  }

  void _submitGrades(String groupName) {
    // Iterate through the grades map to submit each email's grade
    grades.forEach((email, grade) {
      if (grade.isNotEmpty) {
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

  void _viewGrades(String groupName) {
    // Navigate to view grades screen for the selected group
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradesDetailScreen(groupName: groupName),
      ),
    );
  }
}

class GradesDetailScreen extends StatelessWidget {
  final String groupName;

  const GradesDetailScreen({Key? key, required this.groupName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 204, 212),
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent,
        title: Center(child: Text('Grades Detail Screen')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grades')
            .where('groupName', isEqualTo: groupName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No grades data available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var gradeData = snapshot.data!.docs[index];
              String email = gradeData['email'];
              String grade = gradeData['grade'];

              return ListTile(
                title: Text('Email: $email'),
                subtitle: Text('Grade: $grade'),
              );
            },
          );
        },
      ),
    );
  }
}
