// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String dropdownvalue = 'ڕەگەز';
  String dropdownvalue1 = 'پیشە';
  String dropdownvalue2 = 'بەش';

  List<String> items = ['ڕەگەز', 'نێر', 'مێ'];
  List<String> items2 = ['پیشە', 'مامۆستا', 'خوێندکار'];
  List<String> items3 = ['بەش', 'IT', 'CS', 'MLS', 'Eng', 'BM', 'low'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 228, 226),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ignore: prefer_const_constructors
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  SizedBox(height: 60.0),
                  Text(
                    "خۆتۆمارکردن",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "هەژماریک دروست بکە",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )
                ],
              ),
              Container(
                height: 600,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "ناوی بەکارهێنەر",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Color.fromARGB(255, 207, 226, 233),
                            filled: true,
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "ئیمەیڵ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Color.fromARGB(255, 207, 226, 233),
                            filled: true,
                            prefixIcon: Icon(Icons.email)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "وشەی نهێنی",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(255, 207, 226, 233),
                          filled: true,
                          prefixIcon: Icon(Icons.password),
                        ),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 207, 226, 233),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: DropdownButton(
                            hint: Text('ڕەگەز'),
                            value: dropdownvalue,
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor: Color.fromARGB(255, 207, 226, 233),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            }),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 207, 226, 233),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: DropdownButton(
                            hint: Text('بەش'),
                            value: dropdownvalue2,
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor: Color.fromARGB(255, 207, 226, 233),
                            items: items3.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue2 = newValue!;
                              });
                            }),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 207, 226, 233),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: DropdownButton(
                            hint: Text('کۆلێژ'),
                            value: dropdownvalue1,
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor: Color.fromARGB(255, 207, 226, 233),
                            items: items2.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue1 = newValue!;
                              });
                            }),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "خۆتۆمارکردن",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor:
                                Color.fromARGB(255, 29, 109, 129),
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "پێشتر خۆت تۆمار کردووە؟",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "چونە ژوورەوەش",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 197, 38, 38)),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
