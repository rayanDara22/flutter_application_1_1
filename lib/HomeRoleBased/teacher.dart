import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/login.dart';
import 'package:flutter_application_1/HomeRoleBased/student.dart';
import 'package:flutter_application_1/Sections/CurentTeachetTopic.dart';
// import 'package:flutter_application_1/Sections/Discussion.dart';
import 'package:flutter_application_1/Sections/Tasks.dart';
import 'package:flutter_application_1/Sections/aatendance.dart';
// import 'package:flutter_application_1/Sections/discussion.dart' as discussion;
import 'package:flutter_application_1/Sections/grading.dart';
import 'package:flutter_application_1/Sections/studentreq.dart';
import 'package:flutter_application_1/Sections/teacherChat.dart';
import 'package:flutter_application_1/Sections/teachertopic.dart';
import 'package:flutter_application_1/Sections/timetable.dart';
import 'package:flutter_application_1/Sections/topics.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 64, 175),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(
          child: Text(
            "Teacher Home Page",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
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
                  _buildCard(context, 'Topic',
                      'https://cdn-icons-png.flaticon.com/512/11450/11450009.png',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TopicP()),
                    );
                  }),
                  _buildCard(context, 'Tasks',
                      'https://cdn-icons-png.flaticon.com/512/10618/10618741.png',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Taskk()),
                    );
                  }),
                  _buildCard(context, 'Grading',
                      'https://cdn-icons-png.flaticon.com/512/7587/7587280.png',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GradingScreen()),
                    );
                  }),
                  _buildCard(context, 'Attendance',
                      'https://cdn-icons-png.flaticon.com/512/6612/6612108.png',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendanceScreen()),
                    );
                  }),
                  _buildCard(context, 'Timetable',
                      'https://cdn.iconscout.com/icon/premium/png-256-thumb/timetable-15-767593.png',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimetableScreen()),
                    );
                  }),
                  _buildCard(context, 'S-Reuqests',
                      'https://th.bing.com/th/id/R.5652602b376e8f04ba5b7af003bd9fa9?rik=%2fRZvy4oi%2bGBD9w&pid=ImgRaw&r=0',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestPage()),
                    );
                  }),
                  _buildCard(context, 'Discussion',
                      'https://cdn-icons-png.flaticon.com/512/1459/1459330.png',
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeacherGroupChatScreen()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String imageUrl,
      {VoidCallback? onPressed}) {
    Color cardColor;
    Color textColor;
    double textSize = 16.0;
    FontWeight textWeight = FontWeight.bold;
    switch (title) {
      case 'Topic':
        cardColor = Color.fromARGB(255, 241, 202, 25);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'Grading':
        cardColor = Color.fromARGB(255, 63, 155, 231);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'Discussion':
        cardColor = const Color.fromARGB(255, 111, 111, 111);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'Attendance':
        cardColor = Color.fromARGB(255, 198, 144, 237);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'Tasks':
        cardColor = Color.fromARGB(255, 129, 248, 45);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;

      case 'Timetable':
        cardColor = Color.fromARGB(255, 250, 43, 43);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'S-Reuqests':
        cardColor = Color.fromARGB(255, 49, 172, 86);
        textColor = Colors.white;
        textSize = 17.0;
        textWeight = FontWeight.bold;
        break;
      default:
        cardColor = Colors.grey;
        textColor = Colors.black;
        break;
    }
    return InkWell(
      onTap: () {
        if (title == 'Topic') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrentTeacherTopics(),
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
        } else if (title == 'Discussion') {
          // Check for 'Request Student' title
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TeacherGroupChatScreen(), // Navigate to RequestScreen for Request Student
            ),
          );
        } else if (title == 'S-Reuqests') {
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
              builder: (context) => AttendanceScreen(),
            ),
          );
        } else if (title == 'Tasks') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Taskk(),
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
        }
      },
      // onTap: onPressed,
      child: Card(
        elevation: 4,
        color: cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: 48,
              width: 48,
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
