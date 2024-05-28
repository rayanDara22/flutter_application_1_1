import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// topic w descriptioni har mamostayak pshan aya lai talaba w atwann request bnern
class TeacherTopicsPage extends StatelessWidget {
  final String teacherId;

  const TeacherTopicsPage({Key? key, required this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
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

// har mamostayak topic w   etaili xoi ahenetawa ba pei idyakai
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
  final TextEditingController emailController1 = TextEditingController();
  final TextEditingController emailController2 = TextEditingController();
  final TextEditingController emailController3 = TextEditingController();

  // Function to handle the "Apply to this topic" button click
  void applyToTopic() async {
    List<String> emails = [
      emailController1.text.trim(),
      emailController2.text.trim(),
      emailController3.text
          .trim(), // aw trima spacey zyaya asretawa lakaty nardny bo naw firestore
    ];

    // Check if the request has already been submitted by the student
    if (requestSubmitted) {
      showAlertDialog(context, 'Request Already Submitted',
          'You have already submitted a request for this topic.');
      return;
    }

    // Check if at least 2 email addresses are provided
    if (emails.any((email) => email.isNotEmpty) && emails.length < 2) {
      showAlertDialog(context, 'Insufficient Emails',
          'Please enter at least 2 valid email addresses to apply to this topic.');
      return;
    }

    // Check if the emails exist in Firestore

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final List<String> existingEmails = [];
    final List<String> nonExistingEmails = [];

    for (String email in emails) {
      if (email.isNotEmpty) {
        QuerySnapshot querySnapshot =
            await usersCollection.where('email', isEqualTo: email).get();

        if (querySnapshot.docs.isNotEmpty) {
          existingEmails.add(email);
        } else {
          nonExistingEmails.add(email);
        }
      }
    }

    if (existingEmails.length < 2) {
      showAlertDialog(context, 'Emails Not Found',
          'Some of the entered email addresses do not exist in our system. Please check and try again.');
      return;
    }

    // Prepare data to be added to the "requests" collection

    Map<String, dynamic> requestData = {
      'studentEmails': existingEmails,
      'teacherId': widget.teacherId,
      'topicName': widget.topicDetails.topicName,
      'GroupName': widget
          .topicDetails.topicName, // Assigning GroupName with the topic name
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
        side: BorderSide(color: Color.fromARGB(255, 253, 250, 31), width: 2.0),
      ),
      color: Color.fromARGB(255, 220, 3, 232),
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
                TextField(
                  controller: emailController1,
                  decoration: InputDecoration(labelText: 'Email 1'),
                ),
                TextField(
                  controller: emailController2,
                  decoration: InputDecoration(labelText: 'Email 2'),
                ),
                TextField(
                  controller: emailController3,
                  decoration: InputDecoration(labelText: 'Email 3'),
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
