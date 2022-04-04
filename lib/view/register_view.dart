import 'package:flutter/material.dart';
import 'package:flutterapp/const/routes.dart';
import 'package:flutterapp/service/auth/auth_exception.dart';
import 'package:flutterapp/service/auth/auth_service.dart';

import '../component/error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: _password,
            enableSuggestions: false,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await AuthSerivce.firebase().createUser(
                  email: _email.text,
                  password: _password.text,
                );
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(homeRoute, (route) => false);
              }  on WeakPasswordException {
                showErrorDialog(context,
                    title: 'Error', message: 'Weak password');
              } on EmailAlredyInUseException {
                showErrorDialog(context,
                    title: 'Error', message: 'Email already in user');
              } on InvalidEmailException {
                showErrorDialog(context,
                    title: 'Error', message: 'Invalid email');
              } on GenericAuthException {
                showErrorDialog(context,
                    title: 'Error', message: 'Generic error');
              }
            
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
