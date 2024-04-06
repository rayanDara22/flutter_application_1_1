import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HODRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
            child: Text(
          'HOD Requests',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('topicRequests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No topic requests available.');
          }

          // Extract request details from Firestore documents
          List<TopicRequestDetails> requestDetails = snapshot.data!.docs
              .map((doc) => TopicRequestDetails.fromDocument(doc))
              .where((request) =>
                  request.status != 'Accepted' && request.status != 'Denied')
              .toList();

          return ListView.builder(
            itemCount: requestDetails.length,
            itemBuilder: (context, index) {
              return TopicRequestCard(requestDetails[index]);
            },
          );
        },
      ),
    );
  }
}

class TopicRequestDetails {
  final String documentId;
  final String topicName;
  final String description;
  final String teacherId;
  final String status;
  final String similarTopicId;
  final double similarityPercentage;

  TopicRequestDetails({
    required this.documentId,
    required this.topicName,
    required this.description,
    required this.teacherId,
    required this.status,
    required this.similarTopicId,
    required this.similarityPercentage,
  });

  factory TopicRequestDetails.fromDocument(QueryDocumentSnapshot doc) {
    return TopicRequestDetails(
      documentId: doc.id,
      topicName: (doc['topicName'] ?? '').toString(),
      description: (doc['description'] ?? '').toString(),
      teacherId: (doc['teacherId'] ?? '').toString(),
      status: (doc['status'] ?? '').toString(),
      similarTopicId: (doc['similarTopicId'] ?? '').toString(),
      similarityPercentage: (doc['similarityPercentage'] ?? 0).toDouble(),
    );
  }
}

class TopicRequestCard extends StatelessWidget {
  final TopicRequestDetails requestDetails;

  const TopicRequestCard(this.requestDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: const Color.fromARGB(255, 8, 58, 99),
          width: 2.0,
        ),
      ),
      color: const Color.fromARGB(255, 172, 197, 208),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              requestDetails.topicName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description: ${requestDetails.description}',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 8, 58, 99),
                  ),
                ),
                Text(
                  'Similarity Percentage: ${requestDetails.similarityPercentage}%',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 8, 58, 99),
                  ),
                ),
                FutureBuilder(
                  future: getSimilarTopicDetails(requestDetails.similarTopicId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    }
                    final topicDetails = snapshot.data as TopicDetails;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Related Topic: ${topicDetails.topicName}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 8, 58, 99),
                          ),
                        ),
                        Text(
                          'Related Topic Description: ${topicDetails.description}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 8, 58, 99),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  acceptRequest(requestDetails);
                },
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () {
                  denyRequest(requestDetails);
                },
                child: Text('Deny'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<TopicDetails?> getSimilarTopicDetails(String similarTopicId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('topics')
        .doc(similarTopicId)
        .get();
    if (snapshot.exists) {
      return TopicDetails.fromSnapshot(snapshot);
    }
    return null;
  }

  void acceptRequest(TopicRequestDetails request) async {
    await FirebaseFirestore.instance
        .collection('topicRequests')
        .doc(request.documentId)
        .update({'status': 'Accepted'});
    await FirebaseFirestore.instance.collection('topics').add({
      'topicName': request.topicName,
      'description': request.description,
      'teacherID': request.teacherId,
    });
  }

  void denyRequest(TopicRequestDetails request) async {
    await FirebaseFirestore.instance
        .collection('topicRequests')
        .doc(request.documentId)
        .update({'status': 'Denied'});
  }
}

class TopicDetails {
  final String topicName;
  final String description;

  TopicDetails({
    required this.topicName,
    required this.description,
  });

  factory TopicDetails.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TopicDetails(
      topicName: data['topicName'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
