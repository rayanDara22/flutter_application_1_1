import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final String studentEmail;
  final String topicName;
  final String teacherId;
  final String status;

  RequestDetails({
    required this.documentId,
    required this.studentEmail,
    required this.teacherId,
    required this.topicName,
    required this.status,
  });

  factory RequestDetails.fromDocument(QueryDocumentSnapshot doc) {
    return RequestDetails(
      documentId: doc.id,
      studentEmail: (doc['studentEmail'] ?? '').toString(),
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
        side:
            BorderSide(color: const Color.fromARGB(255, 8, 58, 99), width: 2.0),
      ),
      color: const Color.fromARGB(255, 172, 197, 208),
      child: ListTile(
        title: Text(
          'Student Email: ${requestDetails.studentEmail}',
          style: TextStyle(
            color: Colors.white,
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
                // Accept logic here
                acceptRequest(requestDetails.documentId);
              },
              child: Text('Accept'),
            ),
            SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: () {
                // Deny logic here
                denyRequest(requestDetails.documentId);
              },
              child: Text('Deny'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle accepting a request
  void acceptRequest(String documentId) {
    // Update status to "Accepted" in Firestore
    FirebaseFirestore.instance
        .collection('requests')
        .doc(documentId)
        .update({'status': 'Accepted'});

    // Display a success message or perform any other actions
    print('Request accepted successfully!');
  }

  // Function to handle denying a request
  void denyRequest(String documentId) {
    // Update status to "Denied" in Firestore
    FirebaseFirestore.instance
        .collection('requests')
        .doc(documentId)
        .update({'status': 'Denied'});

    // Display a success message or perform any other actions
    print('Request denied successfully!');
  }
}
