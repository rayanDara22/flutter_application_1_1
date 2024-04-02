import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatPageStud extends StatefulWidget {
  @override
  _GroupChatPageStudState createState() => _GroupChatPageStudState();
}

class _GroupChatPageStudState extends State<GroupChatPageStud> {
  late User? currentUser; // Updated to User? to handle potential null value
  late String groupId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    currentUser = FirebaseAuth
        .instance.currentUser; // Use FirebaseAuth.instance.currentUser

    if (currentUser != null) {
      final String currentEmail = currentUser!.email!;

      // Fetch the current user's document
      final DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentEmail)
          .collection('student')
          .doc(currentEmail)
          .get();

      if (userDocSnapshot.exists) {
        final String? fetchedGroupId = userDocSnapshot.get('groupId');
        if (fetchedGroupId != null) {
          setState(() {
            groupId = fetchedGroupId;
          });
        } else {
          print('Error: groupId is null.');
        }
      } else {
        print('Error: No document found for current user.');
      }
    } else {
      print('Error: Current user is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (groupId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Group Chat'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Group Chat'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('group_chats')
              .doc(groupId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No messages available.'));
            }

            // Extract messages from Firestore documents
            List<ChatMessage> messages = snapshot.data!.docs
                .map((doc) => ChatMessage.fromDocument(doc))
                .toList();

            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].message),
                  subtitle: Text(messages[index].sender),
                );
              },
            );
          },
        ),
      );
    }
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final Timestamp timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromDocument(QueryDocumentSnapshot doc) {
    return ChatMessage(
      sender: doc['sender'] ?? '',
      message: doc['message'] ?? '',
      timestamp: doc['timestamp'] ?? Timestamp.now(),
    );
  }
}
