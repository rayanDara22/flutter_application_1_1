import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';

class Auth extends StatelessWidget {
  const Auth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 197, 38, 38),
          //title: Icon(Icons.home),
          elevation: 5.5,
          shadowColor: Color.fromARGB(255, 12, 12, 11),
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 255, 255, 255),
            tabs: [
              Tab(
                
                text: 'چوونە ژوورەوە',
              ),
              Tab(text: 'خۆتۆمارکرد'),
            ],
          ),
        ),
        body: TabBarView(
          
          children: [
            LoginPage(),
            SignupPage(),
          ],
        ),
      ),
    );
  }
}
