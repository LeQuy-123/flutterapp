import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = {
        'name': _email.text,
        'password': _password.text,
      };
      print(user.toString());
    }
  }

  String? _validateInput(String? value) {
    if (value!.isEmpty || value.length > 10) {
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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
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
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Login'),
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
}
