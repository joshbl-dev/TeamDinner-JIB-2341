import 'package:flutter/material.dart';
import 'package:frontend/signup.dart';
import 'package:frontend/widgets/login_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            padding: const EdgeInsets.only(top: 30),
            alignment: Alignment.topRight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/TDlogo.png"),
                )
            ),
          ),
          // const Text(
          //   "TeamDinner",
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 44.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const LoginForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SignUpPage();
                      },
                    ),
                  );
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
