import 'package:flutter/material.dart';
import 'package:flutterapp/service/auth/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key? key }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}
enum menuOptions { 
  logout,
  settings
}

class _HomeViewState extends State<HomeView> {
  Future<bool> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<menuOptions>(
            onSelected: (menuOptions value) async {
              if (value == menuOptions.logout) {
                final data = await showLogoutDialog(context);
                if(data) {
                  AuthSerivce.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<menuOptions>(
                value: menuOptions.logout,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: AuthSerivce.firebase().intialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return const Center(
                  child: Text("Welcome"),
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