import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/login.dart';
import 'package:flutter_application_1/Sections/chat.dart';
import 'package:flutter_application_1/Sections/studentgrade.dart';
import 'package:flutter_application_1/Sections/studentseeTask.dart';
import 'package:flutter_application_1/Sections/topics.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 117, 255),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(
          child: Text(
            "Student Home Page",
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
                    _buildCard(context, 'Topic',
                        'https://cdn-icons-png.flaticon.com/512/11135/11135742.png',
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TopicP()),
                      );
                    }),
                    _buildCard(context, 'Discussion',
                        'https://cdn-icons-png.flaticon.com/512/9740/9740568.png',
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupChatScreen(),
                        ),
                      );
                    }),
                    _buildCard(context, 'Attendance',
                        'https://cdn-icons-png.flaticon.com/512/9934/9934439.png',
                        onPressed: () {}),
                    _buildCard(context, 'Grading',
                        'https://cdn3.iconfinder.com/data/icons/100-education-5/512/62_Best_Grade-512.png',
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GradesPage(),
                        ),
                      );
                    }),
                    _buildCard(context, 'Timetable',
                        'https://cdn0.iconfinder.com/data/icons/mentoring-and-training-16/66/38_schedule_planning_scheme_calendar_appointment-512.png',
                        onPressed: () {}),
                    _buildCard(
                      context,
                      'Tasks',
                      'https://cdn-icons-png.flaticon.com/512/11364/11364993.png',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentTaskListPage(
                                studentEmail:
                                    FirebaseAuth.instance.currentUser!.email ??
                                        ''),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        cardColor = Color.fromARGB(255, 4, 162, 206);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;

      case 'Attendance':
        cardColor = Color.fromARGB(255, 168, 167, 167);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'Grading':
        cardColor = Color.fromARGB(255, 237, 99, 175);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      case 'Timetable':
        cardColor = Color.fromARGB(255, 202, 216, 10);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;

      case 'Discussion':
        cardColor = Color.fromARGB(255, 238, 84, 67);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;

        break;
      case 'Tasks':
        cardColor = Color.fromARGB(255, 249, 170, 125);
        textColor = Colors.white;
        textSize = 20.0;
        textWeight = FontWeight.bold;
        break;
      default:
        cardColor = Colors.grey;
        textColor = Colors.black;
        break;
    }

    return InkWell(
      onTap: onPressed,
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
}
