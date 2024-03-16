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
  bool isTeacher = false;
  TextEditingController topicNameController = TextEditingController();
  TextEditingController topicDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fetch teachers' data from the 'teacher' subcollection of all users
    teachersStream =
        FirebaseFirestore.instance.collectionGroup('teacher').snapshots();

    // Check if the current user is a teacher
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('teacher')
          .get()
          .then((querySnapshot) {
        setState(() {
          isTeacher = querySnapshot.docs.isNotEmpty;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 20, 20),
        title: Center(
            child: Text(
          "Teachers",
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          if (isTeacher)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Topic'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // Add your form fields here
                            TextField(
                              controller: topicNameController,
                              decoration:
                                  InputDecoration(labelText: 'Topic Name'),
                            ),
                            TextField(
                              controller: topicDescriptionController,
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                            ),
                            // Add more form fields as needed
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () {
                            _addTopicToFirestore();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
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

//addy datay buttoni add topicaka aka bo firebase lasarawa bangman krdotawa
  void _addTopicToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String newTopicName = topicNameController.text;
      String newTopicDescription = topicDescriptionController.text;

      // Fetch existing topics from Firestore
      QuerySnapshot topicsSnapshot = await FirebaseFirestore.instance
          .collection('topics')
          .where('teacherID', isEqualTo: user.uid)
          .get();

      // Check for similarity with existing topics
      bool isSimilarTopic = false;
      topicsSnapshot.docs.forEach((doc) {
        String existingTopicName = doc['topicName'];
        String existingTopicDescription = doc['description'];
        if (areTopicsSimilar(newTopicName, newTopicDescription,
            existingTopicName, existingTopicDescription)) {
          isSimilarTopic = true;
          return;
        }
      });

      if (isSimilarTopic) {
        // Show an alert or error message for similarity found
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Similar Topic Found'),
              content: Text(
                  'A similar topic already exists. Please choose a different topic.'),
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
      } else {
        // Add the topic to Firestore if not similar
        FirebaseFirestore.instance.collection('topics').add({
          'topicName': newTopicName,
          'description': newTopicDescription,
          'teacherID': user.uid,
        });

        // Clear the text controllers after adding
        topicNameController.clear();
        topicDescriptionController.clear();
      }
    }
  }

  /////check similarity akat
  bool areTopicsSimilar(String newTopicName, String newTopicDescription,
      String existingTopicName, String existingTopicDescription) {
    // Calculate Levenshtein Distance for topic names
    int nameDistance =
        calculateLevenshteinDistance(newTopicName, existingTopicName);
    double nameSimilarity = 1 - (nameDistance / newTopicName.length);

    // Calculate Levenshtein Distance for topic descriptions
    int descriptionDistance = calculateLevenshteinDistance(
        newTopicDescription, existingTopicDescription);
    double descriptionSimilarity =
        1 - (descriptionDistance / newTopicDescription.length);

    // Set a similarity threshold (adjust as needed)
    double similarityThreshold = 0.5; // 50% similarity threshold

    // Check if both name and description similarities meet the threshold
    return nameSimilarity >= similarityThreshold &&
        descriptionSimilarity >= similarityThreshold;
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
