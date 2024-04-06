import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Sections/teachertopic.dart';

class TopicP extends StatefulWidget {
  const TopicP({Key? key}) : super(key: key);

  @override
  _TopicPState createState() => _TopicPState();
}

class _TopicPState extends State<TopicP> {
  late Stream<QuerySnapshot> teachersStream;

  @override
  void initState() {
    super.initState();

    // Fetch teachers' data from the 'teacher' subcollection of all users
    teachersStream =
        FirebaseFirestore.instance.collectionGroup('teacher').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 20, 20),
        title: Center(
            child: Text(
          "Student",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: teachersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No teachers available.');
          }

          // Extract teacher names from Firestore documents
          List<String> teacherNames = snapshot.data!.docs
              .map((doc) => (doc['firstName'] ?? '').toString())
              .toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: teacherNames.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                      color: const Color.fromARGB(255, 8, 58, 99), width: 5.0),
                ),
                color: const Color.fromARGB(255, 172, 197, 208),
                child: InkWell(
                  onTap: () async {
                    // Get the teacher's document
                    QuerySnapshot snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .where('firstName', isEqualTo: teacherNames[index])
                        .limit(1)
                        .get();

                    // Check if the teacher's document exists
                    if (snapshot.docs.isNotEmpty) {
                      // Get the teacher's ID
                      String teacherId = snapshot.docs.first.id;

                      // Navigate to TeacherTopicsPage when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherTopicsPage(
                            teacherId: teacherId,
                          ),
                        ),
                      );
                    }
                  },
                  child: Center(
                    child: Text(
                      teacherNames[index],
                      style: TextStyle(
                        fontSize: 18.0,
                        color: const Color.fromARGB(255, 8, 58, 99),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
