import 'package:flutter/material.dart';

class IndividualPaymentPage extends StatefulWidget {
  const IndividualPaymentPage({Key? key}) : super(key: key);

  @override
  State<IndividualPaymentPage> createState() => _IndividualPaymentPageState();
}

class _IndividualPaymentPageState extends State<IndividualPaymentPage> {
  final formKey = GlobalKey<FormState>();
  final paymentController = TextEditingController();
  // Format and Function of the personalized payments
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back arrow
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
            // Text field to enter how much has been paid and how much a user has sent
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: paymentController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Amount Member Has Paid";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Please Enter the Amount Member Has Sent",
                        prefixIcon: Icon(Icons.money, color: Colors.black),
                      ),
                    ),
                  ),
                  // Button to confirm what the user has paid to you
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.deepPurple[300],
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      onPressed: () async{},
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
