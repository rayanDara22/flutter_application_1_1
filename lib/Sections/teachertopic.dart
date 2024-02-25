import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
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
              .map((doc) => TopicDetails.fromDocument(doc))
              .toList();

          return ListView.builder(
            itemCount: topicDetails.length,
            itemBuilder: (context, index) {
              return TopicCard(topicDetails[index]);
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

  TopicDetails({
    required this.topicName,
    required this.description,
  });

  factory TopicDetails.fromDocument(QueryDocumentSnapshot doc) {
    return TopicDetails(
      topicName: (doc['topicName'] ?? '').toString(),
      description: (doc['description'] ?? '').toString(),
    );
  }
}

class TopicCard extends StatelessWidget {
  final TopicDetails topicDetails;

  const TopicCard(this.topicDetails);

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
        title: Text(
          topicDetails.topicName,
          style: TextStyle(
              color: Colors
                  .white), // Set text color to white for better visibility
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              topicDetails.description,
              style: TextStyle(
                  fontSize: 16.0, color: const Color.fromARGB(255, 8, 58, 99)),
            ),
          ),
        ],
      ),
    );
  }
}
