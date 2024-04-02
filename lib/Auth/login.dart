import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/HomeRoleBased/headofdep.dart';
import 'package:flutter_application_1/HomeRoleBased/student.dart';
import 'package:flutter_application_1/HomeRoleBased/teacher.dart';

import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 80,
        title: Text(
          'Login ',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 207, 226, 233),
                Color.fromARGB(255, 167, 20, 20)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 207, 226, 233),
        child: Column(
          children: <Widget>[
            Center(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: 200,
                        child: Image.asset("imgs/logo.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Email',
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                            left: 14.0,
                            bottom: 8.0,
                            top: 8.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _isObscure3,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure3
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure3 = !_isObscure3;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                            left: 14.0,
                            bottom: 14.0,
                            top: 15.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid password (min. 6 characters)';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              elevation: 5.0,
                              height: 60,
                              onPressed: () {
                                setState(() {
                                  visible = true;
                                });
                                signIn(
                                  emailController.text,
                                  passwordController.text,
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              color: Color.fromARGB(255, 29, 109, 129),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              elevation: 5.0,
                              height: 60,
                              onPressed: () {
                                CircularProgressIndicator();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Register(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              color: Color.fromARGB(255, 29, 109, 129),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void routeBasedOnUserRole(String role) {
    if (role == 'Student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Student()),
      );
    } else if (role == 'Teacher') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Teacher()),
      );
    } else {
      print('Invalid user role, please register first');
    }
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      checkAndNavigate(user);
    }
  }

  /// loginy head of departmentakaia ba pei uid acheta nawawa   , accountakam la backednawa drustkrdwa

  void checkAndNavigate(User user) {
    if (user.uid == '0Rww1GvPM6dE4MRfSz45jrejOsq2') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HeadOfDepartment()),
      );
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot userSnapshot) {
        if (userSnapshot.exists) {
          String role = userSnapshot.get('rool');
          routeBasedOnUserRole(role);
        } else {
          print('User not found, please register first');
        }
      });
    }
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar(context, 'Wrong email or password.');
        } else if (e.code == 'wrong-password') {
          showSnackBar(context, 'Wrong email or password.');
        }
      }
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
