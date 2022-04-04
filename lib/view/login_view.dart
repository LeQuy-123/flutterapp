import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/const/routes.dart';
import 'package:flutterapp/service/auth/auth_exception.dart';
import 'package:flutterapp/service/auth/auth_service.dart';
import '../component/error_dialog.dart';
import 'dart:developer' as dev_tools;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email  = TextEditingController()..text = '';
  late final TextEditingController _password  = TextEditingController()..text = '';
  int _state = 0;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    dev_tools.log('subbmit');
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _state = 1;
        });
        await AuthSerivce.firebase().logIn(email: _email.text, password: _password.text);
        _formKey.currentState!.reset();
        setState(() {
          _state = 2;
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil(homeRoute, (route) => false);
      } on UserNotFoundException {
        showErrorDialog(context, title: 'Error', message: 'User not found');
        setState(() {
          _state = 0;
        });
      } on WrongPassWordException {
        showErrorDialog(context, title: 'Error', message: 'Wrong password');
        setState(() {
          _state = 0;
        });
      } on GenericAuthException  {
        showErrorDialog(context, title: 'Error', message: 'Error');
        setState(() {
          _state = 0;
        });
      }
    }
  }

  String? _validateInput(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a valid input';
    } return null;
  }

  void _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
        future: AuthSerivce.firebase().intialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: _emailFocusNode,
                      validator: _validateInput,
                      autocorrect: false,
                      controller: _email,
                      onFieldSubmitted: (String value) {
                        _nextFocus(_passwordFocusNode);
                      },
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      validator: _validateInput,
                      autocorrect: false,
                      obscureText: true,
                      controller: _password,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, registerRoute);
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    MaterialButton(
                      child: setUpButtonChild(),
                      onPressed: () {
                        if (_state == 0) {
                          _submitForm();
                        }
                      },
                      elevation: 4.0,
                      minWidth: double.infinity,
                      height: 48.0,
                      color: Colors.lightGreen,
                    ),
                  ],
                ),
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return const Text(
        "Click Here",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }
}
