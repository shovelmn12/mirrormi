import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('נא הכניס\/י מילה בטוחה'),
              const SizedBox(
                height: 16,
              ),
              TextField(
                onSubmitted: (_) => Navigator.of(context).pushNamed('home'),
              ),
            ],
          ),
        ),
      );
}
