import 'package:flutter/material.dart';
import 'package:frontend/new_team.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({Key? key}) : super(key: key);

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}
// Create the "create team page"
class _CreateTeamPageState extends State<CreateTeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listView(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        centerTitle: true,
        title: const Text('T E A M   R E Q U E S T S'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CreateNewTeamPage();
                  },
                )
            );
          },
              icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

Widget listView() {
  return ListView.separated(
      itemBuilder: (context, index) {
        return listViewItem(index);
  },
  separatorBuilder: (context, index) {
        return const Divider(height: 0);
  },
      itemCount: 15
  );
}
Widget prefixIcon() {
  return Container(
    height: 50,
    width: 50,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey.shade300,
    ),
    child: Icon(Icons.people, size: 25, color: Colors.grey.shade700,),
  );
}
Widget listViewItem(int index) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        prefixIcon(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message(index),
                timeAndDate(index),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
// Layout of displaying team and team description
Widget message(int index) {
  double textSize = 14;
  return RichText(
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(
      text: 'Team',
      style: TextStyle(
        fontSize: textSize,
        color:  Colors.black,
        fontWeight: FontWeight.bold,
      ),
      children: const [
        TextSpan(
          text: 'Team Description',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          )
        )
      ]
    ),
  );
}
// Hard coded date and time of team creation to test functionality
Widget timeAndDate(int index) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          '16-02-2021',
          style: TextStyle(
            fontSize: 10,
          ),
        ),
        Text(
          '8:00 pm',
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    )
  );
}