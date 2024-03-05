import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/login.dart';
import 'package:flutter_application_1/Sections/topics.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 226, 233),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 20, 20),
        title: Center(
            child: Text(
          "Student Home Page",
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
      body: Center(
        child: Padding(
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
                    _buildCard(context, 'Discussion', Icons.mark_as_unread,
                        onPressed: () {}),
                    _buildCard(context, 'Attendance', Icons.date_range_sharp,
                        onPressed: () {}),
                    _buildCard(context, 'Grading', Icons.date_range_sharp,
                        onPressed: () {}),
                    _buildCard(context, 'Timetable', Icons.punch_clock,
                        onPressed: () {}),
                    _buildCard(context, 'Tasks', Icons.note, onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
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
      case 'Discussion':
        cardColor = Color.fromARGB(255, 63, 155, 231);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Attendance':
        cardColor = const Color.fromARGB(255, 111, 111, 111);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Grading':
        cardColor = Color.fromARGB(255, 237, 99, 175);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Timetable':
        cardColor = Color.fromARGB(255, 138, 98, 83);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 14.0;
        textWeight = FontWeight.bold;
        break;
      case 'Tasks':
        cardColor = Color.fromARGB(255, 220, 164, 61);
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
        } else {
          onPressed?.call();
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
