import 'package:flutter/material.dart';
import 'package:flutterapp/view/login_view.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
    ));
}

