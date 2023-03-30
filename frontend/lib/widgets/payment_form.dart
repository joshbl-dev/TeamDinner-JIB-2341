import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final formKey = GlobalKey<FormState>();
  final paymentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pending Payments:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                "Total Amount Owed For Dinner",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                              return "Please Enter Dinner Total";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Total Dinner Cost",
                            prefixIcon: Icon(Icons.money, color: Colors.black),
                          ),
                        ),
                    ),
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
                          "Split Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      )
    );
  }
}
