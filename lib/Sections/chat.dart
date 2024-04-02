import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Sections/discussion.dart'; // Import the correct GroupDetails class

// Your GroupChatPage code here...

class GroupChatPage extends StatefulWidget {
  final GroupDetails groupDetails; // No need for 'discussion.' prefix here

  GroupChatPage(this.groupDetails);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat - ${widget.groupDetails.groupId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('group_chats')
                  .doc(widget.groupDetails.groupId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No messages yet.'));
                }

                var data = snapshot.data!.data() as Map<String, dynamic>?;

                if (data == null || !data.containsKey('messages')) {
                  return Center(child: Text('No messages yet.'));
                }

                var messages = data['messages'] as List?;

                if (messages == null || messages.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['text'] ?? ''),
                      subtitle:
                          Text('Sent by: ${message['senderEmail'] ?? ''}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String text) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var messageData = {
        'text': text,
        'senderEmail': currentUser.email,
        'timestamp': Timestamp.now(),
      };

      var chatDocRef = FirebaseFirestore.instance
          .collection('group_chats')
          .doc(widget.groupDetails.groupId);

      try {
        var chatDoc = await chatDocRef.get();
        if (!chatDoc.exists) {
          // Create the document if it doesn't exist
          await chatDocRef.set({
            'messages': [messageData], // Start with the new message
          });
        } else {
          // Document exists, update the messages array
          await chatDocRef.update({
            'messages': FieldValue.arrayUnion([messageData]),
          });
        }

        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
        // Handle error (show snackbar, toast, etc.)
      }
    }
  }
}
