import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/login.dart';
import 'package:flutter_application_1/Sections/aatendance.dart';
import 'package:flutter_application_1/Sections/grading.dart';
import 'package:flutter_application_1/Sections/studentreq.dart';
import 'package:flutter_application_1/Sections/teachertopic.dart';
import 'package:flutter_application_1/Sections/timetable.dart';
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
      backgroundColor: const Color.fromARGB(255, 207, 226, 233),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 59, 20, 167),
        title: Center(
            child: Text(
          "Teacher Home Page",
          style: TextStyle(
            color: Colors.white,
          ),
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
      body: Padding(
        padding: EdgeInsets.only(top: 25.0),
        child: Column(
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
                  _buildCard(context, 'Tasks', Icons.topic_outlined,
                      onPressed: () {}),
                  _buildCard(context, 'Discussion', Icons.mark_as_unread,
                      onPressed: () {}),
                  _buildCard(context, 'Grading', Icons.date_range_sharp,
                      onPressed: () {}),
                  _buildCard(context, 'Attendance', Icons.note,
                      onPressed: () {}),
                  _buildCard(context, 'Timetable', Icons.punch_clock,
                      onPressed: () {}),
                  _buildCard(context, 'Students Requests', Icons.person,
                      onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      {VoidCallback? onPressed}) {
    Color cardColor;
    Color iconColor;
    Color textColor;
    double textSize = 16.0;
    FontWeight textWeight = FontWeight.bold;
    switch (title) {
      case 'Topic':
        cardColor = Color.fromARGB(255, 241, 202, 25);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Grading':
        cardColor = Color.fromARGB(255, 63, 155, 231);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Discussion':
        cardColor = const Color.fromARGB(255, 111, 111, 111);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Attendance':
        cardColor = Color.fromARGB(255, 144, 14, 236);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Tasks':
        cardColor = Color.fromARGB(255, 237, 99, 175);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;

      case 'Timetable':
        cardColor = Color.fromARGB(255, 220, 164, 61);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Students Requests':
        cardColor = Color.fromARGB(255, 143, 241, 73);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      default:
        cardColor = Colors.grey;
        iconColor = Colors.grey;
        textColor = Colors.black;
        break;
    }
    return InkWell(
      onTap: () {
        if (title == 'Topic') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TopicP(), // Navigate to DetailsScreen for Topic
            ),
          );
        } else if (title == 'Grading') {
          // Check for 'Request Student' title
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  GradingScreen(), // Navigate to RequestScreen for Request Student
            ),
          );
        } else if (title == 'Timetable') {
          // Check for 'Request Student' title
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TimetableScreen(), // Navigate to RequestScreen for Request Student
            ),
          );
        } else if (title == 'Students Requests') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RequestPage(), // Navigate to DetailsScreen for Topic
            ),
          );
        } else if (title == 'Attendance') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AttendanceScreen(), // Navigate to DetailsScreen for Topic
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        color: cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: iconColor,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: textWeight,
              ),
              textAlign: TextAlign.center,
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
