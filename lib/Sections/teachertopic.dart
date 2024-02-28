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
        title: Text(
          'Teacher Topics',
          style: TextStyle(color: Colors.white),
        ),
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
  bool requestSubmitted = false;

  // Function to handle the "Apply to this topic" button click
  void applyToTopic() async {
    // Retrieve the current user's email
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? '';

    // Check if the request has already been submitted by the student
    if (requestSubmitted) {
      showAlertDialog(context, 'Request Already Submitted',
          'You have already submitted a request for this topic.');
      return;
    }

    // Prepare data to be added to the "requests" collection
    Map<String, dynamic> requestData = {
      'studentEmail': userEmail,
      'teacherId': widget.teacherId,
      'topicName': widget.topicDetails.topicName,
      'status': 'Pending', // You can set an initial status
    };

    // Add data to the "requests" collection in Firebase
    await FirebaseFirestore.instance.collection('requests').add(requestData);

    // Set the flag to true indicating that the request has been submitted
    setState(() {
      requestSubmitted = true;
    });

    // Display a success message or perform any other actions
    showAlertDialog(
        context, 'Request Submitted', 'Your request has been submitted.');
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

  // Function to show an alert dialog
  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
