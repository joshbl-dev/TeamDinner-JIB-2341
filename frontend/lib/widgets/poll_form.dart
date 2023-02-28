import 'package:flutter/material.dart';
import 'package:frontend/pages/poll.dart';

class PollForm extends StatefulWidget {
  const PollForm({Key? key}) : super(key: key);

  @override
  State<PollForm> createState() => _PollFormState();
}

class _PollFormState extends State<PollForm> {
  bool? isChecked = false;

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
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: IconButton(
                  color: Colors.deepPurple[300],
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
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Create a Poll",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a restaurant";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Restaurant 1",
                        prefixIcon: Icon(Icons.restaurant, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Restaurant";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Restaurant 2",
                        prefixIcon: Icon(Icons.restaurant, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Restaurant";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Restaurant 3",
                        prefixIcon: Icon(Icons.restaurant, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Restaurant";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Restaurant 4",
                        prefixIcon: Icon(Icons.restaurant, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a meeting location";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Meeting Location",
                        prefixIcon: Icon(Icons.location_city, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a meeting time";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Meeting time",
                        prefixIcon: Icon(Icons.punch_clock, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CheckboxListTile(
                      title: const Text("Enable Multiple Restaurant Selections"),
                      value: isChecked,
                      activeColor: Colors.blue,
                      tristate: false,
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      },
                    )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CheckboxListTile(
                        title: const Text("Enable Alcohol Menu"),
                        value: isChecked,
                        activeColor: Colors.blue,
                        tristate: false,
                        onChanged: (newBool) {
                          setState(() {
                            isChecked = newBool;
                          });
                        },
                      )
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.deepPurple[300],
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder:(context) => const PollPage())
                        );
                      },
                      child: const Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
