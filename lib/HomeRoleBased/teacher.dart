import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/login.dart';
import 'package:flutter_application_1/Sections/topics.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _StudentState();
}

class _StudentState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 20, 20),
        title: Center(
            child: Text(
          "Teacher Home Page",
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout_rounded,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: EdgeInsets.all(16),
              children: [
                _buildCard(context, 'Topic', Icons.topic_outlined,
                    onPressed: () {}),
                _buildCard(context, 'Registration', Icons.app_registration,
                    onPressed: () {}),
                _buildCard(context, 'Examination', Icons.mark_as_unread,
                    onPressed: () {}),
                _buildCard(context, 'Survey', Icons.date_range_sharp,
                    onPressed: () {}),
                _buildCard(context, 'Course Material', Icons.note,
                    onPressed: () {}),
                _buildCard(context, 'Timetable', Icons.punch_clock,
                    onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      {VoidCallback? onPressed}) {
    return InkWell(
      onTap: () {
        if (title == 'Topic') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicP(),
            ),
          );
        } else {
          onPressed?.call();
        }
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  // appBar: AppBar(
  //   title: Text("Student"),
  //   actions: [
  //     IconButton(
  //       onPressed: () {
  //         logout(context);
  //       },
  //       icon: Icon(
  //         Icons.logout,
  //       ),
  //     )
  //   ],
  // ),
}

Future<void> logout(BuildContext context) async {
  CircularProgressIndicator();
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}
