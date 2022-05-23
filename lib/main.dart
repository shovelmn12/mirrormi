import 'package:flutter/material.dart';
import 'package:untitled/chat.dart';
import 'package:untitled/login.dart';

void main() async => runApp(const MyApp());

Widget _buildHome(BuildContext context) => const ChatPage();

Widget _builder(BuildContext context, Widget? child) => Directionality(
      textDirection: TextDirection.rtl,
      child: child ?? const SizedBox.shrink(),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'MirrorMe',
        locale: Locale('he', 'IL'),
        routes: {
          'home': _buildHome,
        },
        home: LoginPage(),
        builder: _builder,
      );
}
