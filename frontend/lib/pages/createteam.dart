import 'package:flutter/material.dart';

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text (
            "Yes",
          ),
        ],
      )
    );
  }
}
