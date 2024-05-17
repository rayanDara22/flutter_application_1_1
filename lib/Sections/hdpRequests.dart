import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('topicRequests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No topic requests available.'));
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

  TopicRequestDetails({
    required this.documentId,
    required this.topicName,
    required this.description,
    required this.teacherId,
    required this.status,
  });

  factory TopicRequestDetails.fromDocument(QueryDocumentSnapshot doc) {
    return TopicRequestDetails(
      documentId: doc.id,
      topicName: (doc['topicName'] ?? '').toString(),
      description: (doc['description'] ?? '').toString(),
      teacherId: (doc['teacherId'] ?? '').toString(),
      status: (doc['status'] ?? '').toString(),
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
            subtitle: Text(
              'Description: ${requestDetails.description}',
              style: TextStyle(
                color: const Color.fromARGB(255, 8, 58, 99),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _handleAcceptRequest(context, requestDetails);
                },
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () {
                  _handleDenyRequest(requestDetails);
                },
                child: Text('Deny'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAcceptRequest(
      BuildContext context, TopicRequestDetails request) async {
    // Fetch all existing topics
    QuerySnapshot topicsSnapshot =
        await FirebaseFirestore.instance.collection('topics').get();

    // Calculate similarity with existing topics
    List<SimilarityResult> similarityResults = topicsSnapshot.docs.map((doc) {
      TopicDetails existingTopic = TopicDetails.fromSnapshot(doc);
      double similarityPercentage =
          SimilarityUtil.calculateSimilarityPercentage(
        request.topicName,
        request.description,
        existingTopic.topicName,
        existingTopic.description,
      );
      return SimilarityResult(
          existingTopic: existingTopic,
          similarityPercentage: similarityPercentage);
    }).toList();

    // Filter for similar topics above a certain threshold (e.g., 30%)
    List<SimilarityResult> similarTopics = similarityResults
        .where((result) => result.similarityPercentage > 30)
        .toList();

    // Save the similarity results to Firestore
    await FirebaseFirestore.instance
        .collection('similarities')
        .doc(request.documentId)
        .set({
      'similarTopics': similarTopics
          .map((result) => {
                'topicName': result.existingTopic.topicName,
                'description': result.existingTopic.description,
                'similarityPercentage': result.similarityPercentage,
              })
          .toList(),
    });

    // Show a dialog with the similarity results
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Similar Topics'),
          content: SingleChildScrollView(
            child: ListBody(
              children: similarTopics.map((result) {
                return ListTile(
                  title: Text(
                      '${result.existingTopic.topicName} (${result.similarityPercentage.toStringAsFixed(2)}%)'),
                  subtitle: Text(result.existingTopic.description),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Accept the topic
                _confirmAcceptRequest(request);
                Navigator.of(context).pop();
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _confirmAcceptRequest(TopicRequestDetails request) async {
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

  void _handleDenyRequest(TopicRequestDetails request) async {
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

class SimilarityResult {
  final TopicDetails existingTopic;
  final double similarityPercentage;

  SimilarityResult({
    required this.existingTopic,
    required this.similarityPercentage,
  });
}

class SimilarityUtil {
  static double calculateSimilarityPercentage(
    String newTopicName,
    String newTopicDescription,
    String existingTopicName,
    String existingTopicDescription,
  ) {
    // Calculate Levenshtein Distance for topic names
    int nameDistance =
        _calculateLevenshteinDistance(newTopicName, existingTopicName);
    double nameSimilarity =
        1 - (nameDistance / max(newTopicName.length, existingTopicName.length));

    // Calculate Levenshtein Distance for topic descriptions
    int descriptionDistance = _calculateLevenshteinDistance(
        newTopicDescription, existingTopicDescription);
    double descriptionSimilarity = 1 -
        (descriptionDistance /
            max(newTopicDescription.length, existingTopicDescription.length));

    // Average the similarity percentages for name and description
    return (nameSimilarity + descriptionSimilarity) / 2 * 100;
  }

  static int _calculateLevenshteinDistance(String text1, String text2) {
    // Initialize the Levenshtein Distance matrix
    List<List<int>> distanceMatrix = List.generate(
        text1.length + 1, (i) => List<int>.filled(text2.length + 1, 0));

    // Initialize the first row and column of the matrix
    for (int i = 0; i <= text1.length; i++) {
      distanceMatrix[i][0] = i;
    }
    for (int j = 0; j <= text2.length; j++) {
      distanceMatrix[0][j] = j;
    }

    // Fill in the rest of the matrix
    for (int i = 1; i <= text1.length; i++) {
      for (int j = 1; j <= text2.length; j++) {
        int substitutionCost = text1[i - 1] == text2[j - 1] ? 0 : 1;
        distanceMatrix[i][j] = [
          distanceMatrix[i - 1][j] + 1, // Deletion
          distanceMatrix[i][j - 1] + 1, // Insertion
          distanceMatrix[i - 1][j - 1] + substitutionCost // Substitution
        ].reduce(min);
      }
    }

    // Return the Levenshtein Distance (bottom-right cell of the matrix)
    return distanceMatrix[text1.length][text2.length];
  }
}
