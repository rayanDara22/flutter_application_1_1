import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Sections/chat.dart';
import 'package:flutter_application_1/Sections/discussion.dart'
    as discussion; // Import the correct GroupDetails class with an alias

class GroupListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Groups',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(child: Text('No user found.'));
          }

          User user = userSnapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .where('teacherId', isEqualTo: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No groups available.'));
              }

              // Extract group details from Firestore documents
              List<discussion.GroupDetails> groupDetails =
                  snapshot.data!.docs // Use discussion.GroupDetails here
                      .map((doc) => discussion.GroupDetails.fromDocument(doc))
                      .toList();

              return ListView.builder(
                itemCount: groupDetails.length,
                itemBuilder: (context, index) {
                  return GroupCard(groupDetails[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GroupDetails {
  final String groupId;
  final List<String> studentEmails;
  final String teacherId;

  GroupDetails({
    required this.groupId,
    required this.studentEmails,
    required this.teacherId,
  });

  factory GroupDetails.fromDocument(QueryDocumentSnapshot doc) {
    List<String> emails = [];
    if (doc['studentEmails'] is List) {
      emails = List<String>.from(doc['studentEmails'] ?? []);
    }
    return GroupDetails(
      groupId: doc.id,
      studentEmails: emails,
      teacherId: (doc['teacherId'] ?? '').toString(),
    );
  }
}

class GroupCard extends StatelessWidget {
  final discussion.GroupDetails
      groupDetails; // Use discussion.GroupDetails here

  const GroupCard(this.groupDetails);

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
          'Group ID: ${groupDetails.groupId}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'Students: ${groupDetails.studentEmails.join(', ')}',
          style: TextStyle(
            color: const Color.fromARGB(255, 8, 58, 99),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupChatPage(groupDetails),
              ),
            );
          },
          child: Text('Open Group Chat'),
        ),
      ),
    );
  }
}
