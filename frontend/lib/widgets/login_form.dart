import 'package:flutter/material.dart';

import '../Types/token.dart';
import '../api/users_repository.dart';
import '../homepage.dart';

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
  Widget build(BuildContext context) {
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
                    try {
                      var result = await UsersRepository.login(
                          emailController.value.text,
                          passwordController.value.text);
                      emailController.clear();
                      passwordController.clear();
                      // Todo: Replace with proper error message on fail or screen change on success
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder:(context) => const HomePage())
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login success.')));
                      }
                    } on Exception {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login failed.')));
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
