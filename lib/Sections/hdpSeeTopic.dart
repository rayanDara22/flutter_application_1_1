import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class hdpSeeTopic extends StatelessWidget {
  final String teacherId;

  const hdpSeeTopic({Key? key, required this.teacherId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            'Teacher Topics',
            style: TextStyle(color: Colors.white),
          ),
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
            child: Text(
              widget.topicDetails.description,
              style: TextStyle(
                color: const Color.fromARGB(255, 8, 58, 99),
              ),
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
