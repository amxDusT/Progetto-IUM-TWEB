import 'package:flutter/material.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {},
        child: Align(
          alignment: Alignment.center,
          child: Ink(
            width: double.maxFinite,
            //height: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                )),
            child: const Text('Login'),
          ),
        ),
      ),
    );
  }
}
