import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Topic Requests',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (userSnapshot.hasError) {
            return Text('Error: ${userSnapshot.error}');
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Text('No user found.');
          }

          User user = userSnapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requests')
                .where('teacherId', isEqualTo: user.uid)
                .where('status', isEqualTo: 'Pending')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No pending requests for your topics.');
              }

              // Extract request details from Firestore documents
              List<RequestDetails> requestDetails = snapshot.data!.docs
                  .map((doc) => RequestDetails.fromDocument(doc))
                  .toList();

              return ListView.builder(
                itemCount: requestDetails.length,
                itemBuilder: (context, index) {
                  return RequestCard(requestDetails[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class RequestDetails {
  final String documentId;
  final List<String> studentEmails;
  final String topicName;
  final String teacherId;
  final String status;

  RequestDetails({
    required this.documentId,
    required this.studentEmails,
    required this.teacherId,
    required this.topicName,
    required this.status,
  });

  factory RequestDetails.fromDocument(QueryDocumentSnapshot doc) {
    List<String> emails = [];
    if (doc['studentEmails'] is List) {
      emails = List<String>.from(doc['studentEmails'] ?? []);
    }
    return RequestDetails(
      documentId: doc.id,
      studentEmails: emails,
      teacherId: (doc['teacherId'] ?? '').toString(),
      topicName: (doc['topicName'] ?? '').toString(),
      status: (doc['status'] ?? '').toString(),
    );
  }
}

class RequestCard extends StatelessWidget {
  final RequestDetails requestDetails;

  const RequestCard(this.requestDetails);

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
          'Student Emails: ${requestDetails.studentEmails.join(', ')}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'Topic: ${requestDetails.topicName}\nStatus: ${requestDetails.status}',
          style: TextStyle(
            color: const Color.fromARGB(255, 8, 58, 99),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                acceptRequest(
                    requestDetails.documentId, requestDetails, context);
              },
              child: Text('Accept'),
            ),
            SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: () {
                denyRequest(requestDetails.documentId);
              },
              child: Text('Deny'),
            ),
          ],
        ),
      ),
    );
  }

  void acceptRequest(String documentId, RequestDetails requestDetails,
      BuildContext context) async {
    // Check if the student's email is already associated with another group
    bool isAlreadyInGroup =
        await checkIfStudentAlreadyInGroup(requestDetails.studentEmails);

    if (isAlreadyInGroup) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'One of the students is already in another group. Cannot accept this request.'),
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
      return; // Exit the method if the student is already in a group
    }

    // Update request status to "Accepted"
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(documentId)
        .update({'status': 'Accepted'});

    // Generate a unique group name (optional)
    String groupName =
        requestDetails.topicName; // Use the topic name for simplicity
    // You can implement logic to generate a more unique name here

    // Create a new group document with groupName
    DocumentReference groupRef =
        await FirebaseFirestore.instance.collection('groups').add({
      'teacherId': requestDetails.teacherId,
      'studentEmails': requestDetails.studentEmails,
      'groupName': groupName, // Add the groupName field
    });

    String groupId = groupRef.id;

    // Update student users with groupId
    requestDetails.studentEmails.forEach((email) async {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'groupId': groupId,
        });
      }
    });

    // Create a new group chat document in group_chats collection
    await FirebaseFirestore.instance
        .collection('group_chats')
        .doc(groupId)
        .set({
      'groupId': groupId, // Add groupId field to relate to the group
      'teacherId': requestDetails.teacherId, // Add teacherId field
      'messages': [], // Initialize messages as an empty array
    });

    print(
        'Request accepted successfully! Group created with ID: $groupId and name: $groupName');
  }

  Future<bool> checkIfStudentAlreadyInGroup(List<String> studentEmails) async {
    for (String email in studentEmails) {
      QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('studentEmails', arrayContains: email)
          .get();

      if (groupSnapshot.docs.isNotEmpty) {
        return true; // Student is already in a group
      }
    }
    return false; // Student is not in any group
  }

  void denyRequest(String documentId) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(documentId)
        .update({'status': 'Denied'});

    print('Request denied successfully!');
  }
}
