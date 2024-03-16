import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );

    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Navigate to the next screen when animation completes
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to the next screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Register()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 207, 226, 233), // Change the background color as needed
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://th.bing.com/th/id/R.e337e9fac7f384883bc7f0e4194bfaeb?rik=vf7gJjcs4duEBw&pid=ImgRaw&r=0'),
                radius: 100,
              ),
              SizedBox(height: 20),

              // Image.network(
              //   'https://th.bing.com/th/id/R.e337e9fac7f384883bc7f0e4194bfaeb?rik=vf7gJjcs4duEBw&pid=ImgRaw&r=0',
              //   width: 150,
              //   height: 150,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColoredText('G', Colors.red),
                  _buildColoredText('r', Colors.green),
                  _buildColoredText('a', Colors.blue),
                  _buildColoredText('d', Color.fromARGB(255, 155, 155, 3)),
                  _buildColoredText('u', Colors.orange),
                  _buildColoredText('a', Colors.purple),
                  _buildColoredText('t', Colors.teal),
                  _buildColoredText('i', Colors.pink),
                  _buildColoredText('o', Colors.cyan),
                  _buildColoredText('n', Colors.deepPurple),
                  _buildColoredText(' ', Colors.black),
                  _buildColoredText('P', Colors.red),
                  _buildColoredText('r', Colors.green),
                  _buildColoredText('o', Colors.blue),
                  _buildColoredText('j', Color.fromARGB(255, 155, 155, 3)),
                  _buildColoredText('e', Colors.orange),
                  _buildColoredText('c', Colors.purple),
                  _buildColoredText('t', Colors.teal),
                  _buildColoredText(' ', Colors.pink),
                  _buildColoredText('M', Colors.cyan),
                  _buildColoredText('a', Colors.deepPurple),
                  _buildColoredText('n', Colors.black),
                  _buildColoredText('a', Colors.red),
                  _buildColoredText('g', Colors.green),
                  _buildColoredText('e', Colors.blue),
                  _buildColoredText('m', Color.fromARGB(255, 155, 155, 3)),
                  _buildColoredText('e', Colors.orange),
                  _buildColoredText('n', Colors.purple),
                  _buildColoredText('t', Colors.teal),
                  _buildColoredText(' ', Colors.pink),
                  _buildColoredText('S', Colors.cyan),
                  _buildColoredText('y', Colors.deepPurple),
                  _buildColoredText('s', Colors.black),
                  _buildColoredText('t', Colors.red),
                  _buildColoredText('e', Colors.green),
                  _buildColoredText('m', Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColoredText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
