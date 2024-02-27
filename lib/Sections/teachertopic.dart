import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherTopicsPage extends StatelessWidget {
  final String teacherId;

  const TeacherTopicsPage({Key? key, required this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .where('teacherID', isEqualTo: teacherId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No topics available for this teacher.');
          }

          // Extract topic details from Firestore documents
          List<TopicDetails> topicDetails = snapshot.data!.docs
              .map((doc) => TopicDetails.fromDocument(doc, teacherId))
              .toList();

          return ListView.builder(
            itemCount: topicDetails.length,
            itemBuilder: (context, index) {
              return TopicCard(topicDetails[index], teacherId);
            },
          );
        },
      ),
    );
  }
}

class TopicDetails {
  final String topicName;
  final String description;
  final String teacherId;

  TopicDetails({
    required this.topicName,
    required this.description,
    required this.teacherId,
  });

  factory TopicDetails.fromDocument(
      QueryDocumentSnapshot doc, String teacherId) {
    return TopicDetails(
      topicName: (doc['topicName'] ?? '').toString(),
      description: (doc['description'] ?? '').toString(),
      teacherId: teacherId,
    );
  }
}

class TopicCard extends StatefulWidget {
  final TopicDetails topicDetails;
  final String teacherId;

  const TopicCard(this.topicDetails, this.teacherId);

  @override
  _TopicCardState createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  bool applyChecked = false;

  void applyToTopic() async {
    // Get the current user's name from Firebase Authentication
    String? studentName = getCurrentUserName();

    if (studentName != null) {
      // Create a student application object
      StudentApplication application = StudentApplication(
        studentName: studentName,
        topicName: widget.topicDetails.topicName,
        teacherId: widget.teacherId,
      );

      // Add the student application to the 'applications' collection
      await ApplicationService().applyToTopic(application);

      // You might want to perform additional actions after applying
      print('Applied to topic: ${widget.topicDetails.topicName}');
    } else {
      // Handle the case where the user's name is not available
      print('Unable to retrieve user name.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side:
            BorderSide(color: const Color.fromARGB(255, 8, 58, 99), width: 2.0),
      ),
      color: const Color.fromARGB(255, 172, 197, 208),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.topicDetails.topicName,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.topicDetails.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: const Color.fromARGB(255, 8, 58, 99),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: applyToTopic,
                  child: Text('Apply to this topic'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StudentApplication {
  final String studentName;
  final String topicName;
  final String teacherId;

  StudentApplication({
    required this.studentName,
    required this.topicName,
    required this.teacherId,
  });

  factory StudentApplication.fromDocument(QueryDocumentSnapshot doc) {
    return StudentApplication(
      studentName: (doc['studentName'] ?? '').toString(),
      topicName: (doc['topicName'] ?? '').toString(),
      teacherId: (doc['teacherId'] ?? '').toString(),
    );
  }
}

class ApplicationService {
  final CollectionReference applicationsCollection =
      FirebaseFirestore.instance.collection('applications');

  Future<void> applyToTopic(StudentApplication application) async {
    try {
      await applicationsCollection.add({
        'studentName': application.studentName,
        'topicName': application.topicName,
        'teacherId': application.teacherId,
      });
      print('Application added successfully');
    } catch (e) {
      print('Error adding application: $e');
    }
  }
}

String? getCurrentUserName() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.displayName;
}
