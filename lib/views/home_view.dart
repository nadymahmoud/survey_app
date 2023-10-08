import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/views/create_survey.dart';
import 'package:project/views/survey_example.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateSurveyView();
                    },
                  ),
                );
              },
              child: ContainerWidget(
                text: 'Create a Survey',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SurveyExampleView();
                    },
                  ),
                );
              },
              child: ContainerWidget(
                text: 'Survey Example',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 4),
                blurRadius: 12,
              ),
            ]),
        child: Center(
                child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ))
            .animate()
            .fade(delay: Duration(seconds: 1))
            .slideX()
            .tint(color: Color.fromARGB(255, 65, 57, 177))
            .then(delay: Duration(seconds: 2))
            .tint(color: Colors.black)
            .then(delay: Duration(seconds: 1))
            .shakeX(delay: Duration(seconds: 1)),
      ).animate().shakeY(delay: Duration(seconds: 3)),
    );
  }
}
