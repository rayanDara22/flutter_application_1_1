import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// hy mamostaka xoiaty topicakani xoi abine w zyay aka
class CurrentTeacherTopics extends StatefulWidget {
  const CurrentTeacherTopics({Key? key}) : super(key: key);

  @override
  _CurrentTeacherTopicsState createState() => _CurrentTeacherTopicsState();
}

class _CurrentTeacherTopicsState extends State<CurrentTeacherTopics> {
  late Stream<QuerySnapshot> teacherTopicsStream;
  TextEditingController topicNameController = TextEditingController();
  TextEditingController topicDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the stream to fetch topics related to the current teacher, har mamostayak topicakai xoi ahenetawa
    //ka daxli krdwa bapei teacherID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      teacherTopicsStream = FirebaseFirestore.instance
          .collection('topics')
          .where('teacherID', isEqualTo: user.uid)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 33, 137),
        title: Center(
            child: Text(
          'Your Topics',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: teacherTopicsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No topics available for you.');
          }

          // Extract topic details from Firestore documents , nawy topic w descriptionaka ahenetawa
          List<TopicDetails> topicDetails = snapshot.data!.docs
              .map((doc) => TopicDetails.fromDocument(doc))
              .toList();
          // topicakan ba pei designi aw cardai xwarawa pshan ayatawa  ka drustman krdwa ba sheway list agar habw
          return ListView.builder(
            itemCount: topicDetails.length,
            itemBuilder: (context, index) {
              return TopicCard(topicDetails[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Topic'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: topicNameController,
                        decoration: InputDecoration(labelText: 'Topic Name'),
                      ),
                      TextField(
                        controller: topicDescriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addTopicAsRequest();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

// la buttoni saveakaia bangman krdotawa
  void _addTopicAsRequest() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String newTopicName = topicNameController.text;
      String newTopicDescription = topicDescriptionController.text;

      // Fetch existing topics from Firestore
      QuerySnapshot topicsSnapshot = await FirebaseFirestore.instance
          .collection('topics')
          .where('teacherID', isEqualTo: user.uid)
          .get();

      // Initialize variables to track similarity details

      bool isSimilarTopic = false;
      double similarityPercentage = 0; //  nmuna %100 ,rezhay similarityaka
      String similarTopicId = ''; // idy topica hawshewaka warg agre

      topicsSnapshot.docs.forEach((doc) {
        String existingTopicName = doc['topicName'];
        String existingTopicDescription = doc['description'];
        double currentSimilarity = calculateSimilarityPercentage(newTopicName,
            newTopicDescription, existingTopicName, existingTopicDescription);

        if (currentSimilarity > similarityPercentage) {
          similarityPercentage = currentSimilarity;
          isSimilarTopic = true;
          similarTopicId = doc.id;
        }
      });

      if (isSimilarTopic) {
        // Store the request with information about the similar topic
        await FirebaseFirestore.instance.collection('topicRequests').add({
          'topicName': newTopicName,
          'description': newTopicDescription,
          'teacherId': user.uid,
          'status': 'Pending', // Initial status is 'Pending'
          'similarTopicId': similarTopicId, // Store similar topic ID
          'similarityPercentage':
              similarityPercentage, // Store similarity percentage
        });
      } else {
        // Add the topic as a request directly
        await FirebaseFirestore.instance.collection('topicRequests').add({
          'topicName': newTopicName,
          'description': newTopicDescription,
          'teacherId': user.uid,
          'status': 'Pending', // Initial status is 'Pending'
          'similarityPercentage':
              similarityPercentage, // Store similarity percentage (0 if no similarity)
        });
      }

      // Clear the text controllers after adding
      topicNameController.clear();
      topicDescriptionController.clear();
    }
  }

  double calculateSimilarityPercentage(
      String newTopicName,
      String newTopicDescription,
      String existingTopicName,
      String existingTopicDescription) {
    // Calculate Levenshtein Distance for topic names
    int nameDistance =
        calculateLevenshteinDistance(newTopicName, existingTopicName);
    double nameSimilarity =
        1 - (nameDistance / max(newTopicName.length, existingTopicName.length));

    // Calculate Levenshtein Distance for topic descriptions
    int descriptionDistance = calculateLevenshteinDistance(
        newTopicDescription, existingTopicDescription);
    double descriptionSimilarity = 1 -
        (descriptionDistance /
            max(newTopicDescription.length, existingTopicDescription.length));

    // Average the similarity percentages for name and description

    return (nameSimilarity + descriptionSimilarity) / 2 * 100;
  }

  int calculateLevenshteinDistance(String text1, String text2) {
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
        ].reduce((minValue, value) => minValue > value ? value : minValue);
      }
    }

    // Return the Levenshtein Distance (bottom-right cell of the matrix)
    return distanceMatrix[text1.length][text2.length];
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
        side: BorderSide(
          color: const Color.fromARGB(255, 8, 58, 99),
          width: 2.0,
        ),
      ),
      color: const Color.fromARGB(255, 172, 197, 208),
      child: ListTile(
        title: Text(
          topicDetails.topicName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          topicDetails.description,
          style: TextStyle(
            color: const Color.fromARGB(255, 8, 58, 99),
          ),
        ),
      ),
    );
  }
}
