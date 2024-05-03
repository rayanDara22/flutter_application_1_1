import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class TeacherGroupChatScreen extends StatefulWidget {
  @override
  _TeacherGroupChatScreenState createState() => _TeacherGroupChatScreenState();
}

class _TeacherGroupChatScreenState extends State<TeacherGroupChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentTeacherID;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentTeacherID();
  }

  Future<void> getCurrentTeacherID() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentTeacherID = user.uid;
      });
    }
  }

  Future<List<String>> getTeacherGroupIDs() async {
    List<String> groupIDs = [];
    if (currentTeacherID != null) {
      try {
        // Get the groups where the teacher is a member
        QuerySnapshot groupQuerySnapshot = await _firestore
            .collection('groups')
            .where('teacherId', isEqualTo: currentTeacherID)
            .get();

        groupQuerySnapshot.docs.forEach((groupDoc) {
          groupIDs.add(groupDoc.id);
        });
      } catch (e) {
        print('Error getting teacher groups: $e');
      }
    }
    return groupIDs;
  }

  void _sendMessage(String groupId, String messageText) async {
    if (messageText.isNotEmpty) {
      try {
        // Get the current teacher's email
        String? teacherEmail = _auth.currentUser?.email;

        if (teacherEmail != null) {
          // Get the current timestamp
          DateTime currentTime = DateTime.now();

          // Format the timestamp into a readable string
          String formattedTimestamp =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

          // Create the new message object with the formatted timestamp, sender ID, and email
          Map<String, dynamic> newMessage = {
            'text': messageText,
            'sender': currentTeacherID,
            'senderEmail': teacherEmail,
            'timestamp': formattedTimestamp,
          };

          // Update the group chat document to add the new message to the messages array
          await _firestore.collection('group_chats').doc(groupId).update({
            'messages': FieldValue.arrayUnion([newMessage])
          });

          _messageController.clear();
        } else {
          print('Error: Current teacher email is null.');
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
        title: Text('Teacher Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTeacherGroupIDs(),
              builder: (context, AsyncSnapshot<List<String>> groupIdsSnapshot) {
                if (groupIdsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!groupIdsSnapshot.hasData ||
                    groupIdsSnapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No groups found for the teacher.'),
                  );
                }

                List<String> groupIDs = groupIdsSnapshot.data!;
                return ListView.builder(
                  itemCount: groupIDs.length,
                  itemBuilder: (context, index) {
                    String groupId = groupIDs[index];
                    return ListTile(
                      title: Text(
                          'Group $groupId'), // Modify to show group details
                      onTap: () {
                        // Navigate to the group chat screen for the selected group
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupChatScreen(groupId),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GroupChatScreen extends StatefulWidget {
  final String groupId;

  GroupChatScreen(this.groupId);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('group_chats')
                  .doc(widget.groupId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
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
                      _sendMessage(widget.groupId, value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(
                        widget.groupId, _messageController.text.trim());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String groupId, String messageText) async {
    if (messageText.isNotEmpty) {
      try {
        // Get the current teacher's email
        String? teacherEmail = FirebaseAuth.instance.currentUser?.email;

        if (teacherEmail != null) {
          // Get the current timestamp
          DateTime currentTime = DateTime.now();

          // Format the timestamp into a readable string
          String formattedTimestamp =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

          // Create the new message object with the formatted timestamp, sender ID, and email
          Map<String, dynamic> newMessage = {
            'text': messageText,
            'sender': FirebaseAuth.instance.currentUser?.uid,
            'senderEmail': teacherEmail,
            'timestamp': formattedTimestamp,
          };

          // Update the group chat document to add the new message to the messages array
          await _firestore.collection('group_chats').doc(groupId).update({
            'messages': FieldValue.arrayUnion([newMessage])
          });

          _messageController.clear();
        } else {
          print('Error: Current teacher email is null.');
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
