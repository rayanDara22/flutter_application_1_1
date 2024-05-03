import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserID;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUserID();
  }

  Future<void> getCurrentUserID() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    }
  }

  Future<String?> getCurrentUserGroupId() async {
    if (currentUserID != null) {
      try {
        // Get the user's document from the users collection
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUserID).get();
        if (userDoc.exists) {
          // Cast data to Map<String, dynamic>
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          // Extract the groupId from the user's document
          return userData['groupId'] as String?;
        }
      } catch (e) {
        print('Error getting current user groupId: $e');
      }
    }
    return null;
  }

  void _sendMessage(String messageText) async {
    if (messageText.isNotEmpty && currentUserID != null) {
      try {
        String? groupId = await getCurrentUserGroupId();

        if (groupId != null) {
          // Get the current user's email
          String? userEmail = _auth.currentUser?.email;

          if (userEmail != null) {
            // Get the current timestamp
            DateTime currentTime = DateTime.now();

            // Format the timestamp into a readable string
            String formattedTimestamp =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

            // Create the new message object with the formatted timestamp, sender ID, and email
            Map<String, dynamic> newMessage = {
              'text': messageText,
              'sender': currentUserID,
              'senderEmail': userEmail,
              'timestamp': formattedTimestamp,
            };

            // Update the group chat document to add the new message to the messages array
            await _firestore.collection('group_chats').doc(groupId).update({
              'messages': FieldValue.arrayUnion([newMessage])
            });

            _messageController.clear();
          } else {
            print('Error: Current user email is null.');
          }
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getCurrentUserGroupId(),
              builder: (context, AsyncSnapshot<String?> groupIdSnapshot) {
                if (groupIdSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!groupIdSnapshot.hasData || groupIdSnapshot.data == null) {
                  return Center(
                    child: Text('No group chat found.'),
                  );
                }

                String groupId = groupIdSnapshot.data!;
                return StreamBuilder(
                  stream: _firestore
                      .collection('group_chats')
                      .doc(groupId)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!chatSnapshot.hasData || !chatSnapshot.data!.exists) {
                      return Center(
                        child: Text('No group chat details found.'),
                      );
                    }

                    var groupChatData =
                        chatSnapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> messages = groupChatData['messages'] ?? [];

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index]
                            as Map<String, dynamic>; // Explicit cast
                        String senderEmail = message['senderEmail']
                            as String; // Extract sender email
                        String messageText =
                            message['text'] as String; // Extract message text
                        String formattedTimestamp = message['timestamp']
                            as String; // Extract formatted timestamp

                        return ListTile(
                          title: Text(messageText),
                          subtitle: Text(
                              'Sender Email: $senderEmail - Timestamp: $formattedTimestamp'),
                        );
                      },
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
                    onSubmitted: (value) {
                      _sendMessage(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text.trim());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
