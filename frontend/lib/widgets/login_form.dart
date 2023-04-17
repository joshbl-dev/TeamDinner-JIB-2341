import 'package:flutter/material.dart';
import '../Types/token.dart';
import '../homepage.dart';
import '../util.dart';
// Form for login screen functionality
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future<Token>? accessToken;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  // Format and layout of the login screen
  Widget build(BuildContext context) {
    // Text field to enter username and password to login
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an email";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "User Email",
                prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: TextFormField(
              obscureText: true,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "User Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
          ),
          // Todo: Add functionality to this button
          const Text(
            "Don't remember your Password?",
            style: TextStyle(color: Colors.blue),
          ),
          // Button to login to account
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0xFF0069FE),
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                      if (await Util.login(emailController.value.text, passwordController.value.text)) {
                        emailController.clear();
                        passwordController.clear();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder:(context) => const HomePage())
                        );
                        // Error handling for not being able to login
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login failed.')));
                      }
                  }
                },
                child: const Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
