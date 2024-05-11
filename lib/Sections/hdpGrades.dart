import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GradingScreen2 extends StatefulWidget {
  @override
  _GradingScreen2State createState() => _GradingScreen2State();
}

class _GradingScreen2State extends State<GradingScreen2> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showGradesList(); // Show the list of groups and grades
            },
          ),
        ],
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
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Select Grade for Emails in $groupName'),
              content: Container(
                color: Colors.white,
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
        _firestore.collection('hdpGrades').add({
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

  void _showGradesList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Groups and Grades List'),
          content: Container(
            width: double.maxFinite,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGradesList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('grades').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error fetching data');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No grades data available');
        }

        // Group grades by group name
        Map<String, List<DocumentSnapshot>> groupedGrades = {};
        snapshot.data!.docs.forEach((gradeData) {
          String groupName = gradeData['groupName'];
          groupedGrades.putIfAbsent(groupName, () => []);
          groupedGrades[groupName]!.add(gradeData);
        });

        return ListView.builder(
          shrinkWrap: true,
          itemCount: groupedGrades.length,
          itemBuilder: (context, index) {
            String groupName = groupedGrades.keys.elementAt(index);
            List<DocumentSnapshot> groupGrades = groupedGrades[groupName]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupGrades.length,
                  itemBuilder: (context, index) {
                    var gradeData = groupGrades[index];
                    String email = gradeData['email'];
                    String grade = gradeData['grade'];

                    return ListTile(
                      title: Text(email),
                      subtitle: Text('Grade: $grade'),
                    );
                  },
                ),
                Divider(),
              ],
            );
          },
        );
      },
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
      appBar: AppBar(
        title: Text('Grades Detail Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hdpGrades')
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
                title: Text(email),
                subtitle: Text('Grade: $grade'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editGrade(
                        context, gradeData.id); // Pass document ID for editing
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editGrade(BuildContext context, String gradeId) {
    // Implement your logic for editing the grade here
    // You can navigate to a new screen or show a dialog for editing
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Your edit grade dialog/widget
        return AlertDialog(
          title: Text('Edit Grade'),
          content: Text('Implement your edit grade UI here'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Logic for saving edited grade
                // You can use Firestore update method to update the grade
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
