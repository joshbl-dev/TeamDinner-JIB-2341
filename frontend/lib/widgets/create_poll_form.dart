import 'package:flutter/material.dart';
import 'package:frontend/Types/poll_option.dart';
import 'package:frontend/api/polls_repository.dart';

import '../Types/Poll.dart';

class CreatePollForm extends StatefulWidget {
  const CreatePollForm({Key? key}) : super(key: key);

  @override
  State<CreatePollForm> createState() => _CreatePollFormState();
}

class _CreatePollFormState extends State<CreatePollForm> {
  final formKey = GlobalKey<FormState>();
  bool isMultiple = false;
  bool isAlcohol = false;
  TimeOfDay time =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  TextEditingController meetingLocation = TextEditingController();
  TextEditingController meetingTime = TextEditingController();
  TextEditingController topic = TextEditingController();
  TextEditingController description = TextEditingController();
  List options = [TextEditingController(), TextEditingController()];
  int stage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: buildStage(context),
          )),
    );
  }

  void addOption() {
    setState(() {
      options.add(TextEditingController());
    });
  }

  void removeOption() {
    setState(() {
      options.removeLast();
    });
  }

  Widget buildOption(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: options[index],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter an option";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Option ${index + 1}",
          prefixIcon: const Icon(Icons.restaurant, color: Colors.black),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      [Function()? onTap]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a $hintText";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildStage(context) {
    switch (stage) {
      case 0:
        return buildStage0(context);
      case 1:
        return buildStage1();
      default:
        return buildStage0(context);
    }
  }

  Widget buildStage0(context) {
    return Column(
      children: [
        getHeader(),
        buildTextField(topic, "Topic", Icons.topic),
        buildTextField(description, "Description", Icons.description),
        buildTextField(
            meetingLocation, "Meeting Location", Icons.location_city),
        buildTextField(meetingTime, "Meeting Time", Icons.punch_clock,
            () async {
          FocusScope.of(context).requestFocus(FocusNode());

          TimeOfDay? picked = await showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
          );
          if (picked != null) {
            meetingTime.text = picked.format(context); // add this line.
            setState(() {
              time = picked;
            });
          }
        }),
        Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CheckboxListTile(
              title: const Text("Enable Multiple Restaurant Selections"),
              value: isMultiple,
              activeColor: Colors.blue,
              tristate: false,
              onChanged: (newBool) {
                if (newBool != null) {
                  setState(() {
                    isMultiple = newBool;
                  });
                }
              },
            )),
        Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CheckboxListTile(
              title: const Text("Enable Alcohol Menu"),
              value: isAlcohol,
              activeColor: Colors.blue,
              tristate: false,
              onChanged: (newBool) {
                if (newBool != null) {
                  setState(() {
                    isAlcohol = newBool;
                  });
                }
              },
            )),
        getButton()
      ],
    );
  }

  Widget buildStage1() {
    var widgets = [getHeader()];
    widgets
        .addAll(List.generate(options.length, (index) => buildOption(index)));
    widgets.add(getAddRemove());
    widgets.add(getButton());
    return Column(children: widgets);
  }

  Widget getAddRemove() {
    return Row(
      children: [
        Visibility(
          visible: options.length > 2,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.red[300],
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    if (options.length > 2) {
                      setState(() {
                        options.removeLast();
                      });
                    }
                  },
                  child: const Text(
                    "Remove Option",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: options.length < 4,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.green[300],
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    setState(() {
                      options.add(TextEditingController());
                    });
                  },
                  child: const Text(
                    "Add Option",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget getHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: IconButton(
              color: Colors.deepPurple[300],
              onPressed: () {
                if (stage > 0) {
                  setState(() {
                    stage--;
                  });
                } else {
                  Navigator.pop(
                    context,
                  );
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Create a Poll",
            style: TextStyle(
              color: Colors.black,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget getButton() {
    return SizedBox(
      width: double.infinity,
      child: RawMaterialButton(
        fillColor: Colors.deepPurple[300],
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (stage == 1) {
              final now = DateTime.now();
              List<PollOption> options = [];
              for (var i = 0; i < this.options.length; i++) {
                options.add(PollOption("id", this.options[i].text));
              }
              Poll poll = Poll(
                "",
                topic.text,
                description.text,
                DateTime(now.year, now.month, now.day, time.hour, time.minute),
                meetingLocation.text,
                isMultiple,
                options,
              );
              await PollsRepository.create(poll);

              if (mounted) {
                Navigator.pop(
                  context,
                );
              }
            }
            setState(() {
              stage++;
            });
          }
        },
        child: Text(
          stage == 0 ? "Next" : "Create",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
