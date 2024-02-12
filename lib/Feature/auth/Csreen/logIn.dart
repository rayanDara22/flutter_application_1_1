import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "بەخێربێیت",
          style: TextStyle(
              fontFamily: "rudaw",
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        Text(
          "بۆ چونە ژوورەوە تکایە زانیاریەکان پر بکەرەوە",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "ناوی بەکارهینەر",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Color.fromARGB(255, 207, 226, 233),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "وشەی نهێنی",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromARGB(255, 207, 226, 233),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromARGB(255, 29, 109, 129),
          ),
          child: const Text(
            "چوونە ژوورەوە",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        " بیرچوونەوەی وشەی نهێنی",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "ئەکاونتت نییە؟ ",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
        ),
        TextButton(
            onPressed: () {},
            child: const Text(
              "خۆتۆمارکرد",
              style: TextStyle(
                  color: Color.fromARGB(255, 197, 38, 38), fontSize: 20),
            ))
      ],
    );
  }
}
