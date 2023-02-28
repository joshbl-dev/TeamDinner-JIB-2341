import 'package:flutter/material.dart';
import 'package:frontend/widgets/poll_form.dart';

class CreatePollPage extends StatelessWidget {
  const CreatePollPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: IconButton(
                  color: const Color(0xFF0069FE),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Create Poll",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const PollForm(),
          ],
        ),
      ),
    );
  }
}
