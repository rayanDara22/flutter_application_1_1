import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///hy talabaka
class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final TextEditingController _gradeController = TextEditingController();
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUserEmail();
  }

  Future<void> fetchCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email!;
      });
    } else {
      // Handle the case when the user is not authenticated
    }
  }

  Future<void> submitGrade() async {
    final String grade = _gradeController.text.trim();
    if (grade.isNotEmpty) {
      // Store the user's grade in Firestore
      await FirebaseFirestore.instance.collection('grades').doc().set({
        'email': currentUserEmail,
        'grade': grade,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grade submitted successfully!')),
      );
      _gradeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a grade!')),
      );
    }
  }

  Future<double> _fetchTotalGrade() async {
    double totalGrade = 0.0;

    // Fetch grades from 'grades' collection
    QuerySnapshot gradesSnapshot = await FirebaseFirestore.instance
        .collection('grades')
        .where('email', isEqualTo: currentUserEmail)
        .get();
    for (var doc in gradesSnapshot.docs) {
      totalGrade += double.tryParse(doc['grade']) ?? 0.0;
    }

    // Fetch grades from 'hdpGrades' collection
    QuerySnapshot hdpGradesSnapshot = await FirebaseFirestore.instance
        .collection('hdpGrades')
        .where('email', isEqualTo: currentUserEmail)
        .get();
    for (var doc in hdpGradesSnapshot.docs) {
      totalGrade += double.tryParse(doc['grade']) ?? 0.0;
    }

    return totalGrade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 255, 160),
      appBar: AppBar(
        title: Text(
          'Your Grades',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 237, 158, 251),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            FutureBuilder<double>(
              future: _fetchTotalGrade(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error fetching data');
                }
                if (!snapshot.hasData || snapshot.data == 0) {
                  return Text('No grades found for your email');
                }

                double totalGrade = snapshot.data!;
                double gradePercentage = totalGrade /
                    200; // Assuming the total possible grade is 200 (100 from each collection)

                return Column(
                  children: [
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text('Your Final Grade'),
                        subtitle: Text(totalGrade.toStringAsFixed(2)),
                        // trailing: Text(
                        //   '${(gradePercentage * 100).toStringAsFixed(2)}%',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.green,
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }
}
