import 'package:flutter/material.dart';
import 'package:flutter_application_1/Sections/teachertopic.dart';
import 'package:flutter_application_1/Sections/topics.dart';

class HeadOfDepartment extends StatefulWidget {
  const HeadOfDepartment({super.key});

  @override
  State<HeadOfDepartment> createState() => _StudentState();
}

class _StudentState extends State<HeadOfDepartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 197, 208),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 167),
        title: Center(
          child: Text(
            "Head Of Department Home Page",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
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
                _buildCard(context, 'Teachers Requests', Icons.person,
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
    Color cardColor;
    Color iconColor;
    Color textColor;
    double textSize = 16.0;
    FontWeight textWeight = FontWeight.bold;
    switch (title) {
      case 'Topic':
        cardColor = Color.fromARGB(255, 214, 49, 4);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 19.0;
        textWeight = FontWeight.bold;
        break;

      case 'Teachers Requests':
        cardColor = Color.fromARGB(255, 158, 27, 153);
        iconColor = Colors.white;
        textColor = Colors.white;
        textSize = 19.0;
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
        } else if (title == 'Teachers Requests') {
          // Check for 'Request Student' title
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         teacherRequest(), // Navigate to RequestScreen for Request Student
          //   ),
          // );
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
