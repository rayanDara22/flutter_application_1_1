import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTaskListPage extends StatelessWidget {
  final String studentEmail;

  const StudentTaskListPage({Key? key, required this.studentEmail})
      : super(key: key);

  Future<String?> _fetchGroupName() async {
    try {
      // Query the 'groups' collection to get the group name based on student's email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('studentEmails', arrayContains: studentEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['groupName'];
      }
    } catch (e) {
      print('Error fetching group name: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 223, 254),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 144, 236),
        title: Center(child: Text('My Tasks')),
      ),
      body: FutureBuilder<String?>(
        future: _fetchGroupName(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data == null) {
            return Center(child: Text('Error fetching group information'));
          }

          String groupName = snapshot.data!;

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('groupName',
                    isEqualTo: groupName) // Filter tasks by group name
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching tasks'));
              } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return Center(child: Text('No tasks found for this group'));
              }

              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var task = snapshot.data.docs[index];
                  return ListTile(
                    title: Text(task['title'] ?? ''),
                    subtitle: Text(task['description'] ?? ''),
                    trailing: Text(task['status'] ??
                        ''), // Show the status under each task
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
