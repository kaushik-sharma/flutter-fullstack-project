import 'package:budget_tracker/pages/auth_page.dart';
import 'package:budget_tracker/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20).copyWith(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Easily\nMonitor Your\nExpenses.',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Easily take control of your finances with our intuitive interface. Set goals, track progress, and stay on top of your financial journey.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 60),
            CustomButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
              text: 'Get Started',
            ),
          ],
        ),
      ),
    );
  }
}
