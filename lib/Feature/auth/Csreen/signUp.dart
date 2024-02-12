import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});


  @override


  Widget build(BuildContext context) {
    return 
      
      Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 153, 153, 109),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "خۆتۆمارکردن",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "هەژماریک دروست بکە",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "ناوی بەکارهێنەر",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                        ),
                      ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextField(
                          //                           decoration: InputDecoration(
                          //     hintText: "ناوی باوک",
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(18),
                          //         borderSide: BorderSide.none),
                          //     fillColor: Color.fromARGB(255, 219, 171, 75),
                          //     filled: true,
                          //     prefixIcon: const Icon(Icons.person)),
                          //                         ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextField(
                          //                           decoration: InputDecoration(
                          //     hintText: "ناوی باپیر",
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(18),
                          //         borderSide: BorderSide.none),
                          //     fillColor: Color.fromARGB(255, 219, 171, 75),
                          //     filled: true,
                          //     prefixIcon: const Icon(Icons.person)),
                          //                         ),
                          // ),
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                              hintText: "تەمەن ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.timelapse)
                              ),
                                                  ),
                          ),    Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                                    decoration: InputDecoration(
                              hintText: " بەش",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.book)),
                                                  ),
                          ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                                      decoration: InputDecoration(
                              hintText: "گروپ ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.book_online)),
                                                    ),
                            ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: TextField(
                                                     decoration: InputDecoration(
                              hintText: "کۆلێژ ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.add_home)),
                                                   ),
                           ),
                      
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "ئیمەیڵ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor:const Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.email)),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "وشەی نهێنی",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: const Color.fromARGB(255, 207, 226, 233),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                        ),
                      ),
                     
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "دووپات کردنەوەی وشەی نهێنی",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: const Color.fromARGB(255, 207, 226, 233),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "خۆتۆمارکردن",
                          style: TextStyle(fontSize: 20 , color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:Color.fromARGB(255, 29, 109, 129),
                        ),
                      )),
                  const Center(child: Text("یان")),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 252),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 29, 109, 129),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                          
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/login_signup/google.png'),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Text(
                            "چونە ژورەوە لەگەڵ گۆگڵ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "پێشتر خۆت تۆمار کردووە؟",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0) , fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "چونە ژوورەوەش",
                            style: TextStyle(
                                color:Color.fromARGB(255, 197, 38, 38)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
  
  }
}