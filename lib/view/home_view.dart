import 'package:flutter/material.dart';
import 'package:flutterapp/service/auth/auth_service.dart';
import 'package:flutterapp/service/crud/notes_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key? key }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}
enum MenuOptions { 
  logout,
  settings
}

class _HomeViewState extends State<HomeView> {

  late final NotesService _notesService;
  String get userEmail => AuthSerivce.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<MenuOptions>(
            onSelected: (MenuOptions value) async {
              if (value == MenuOptions.logout) {
                final data = await showLogoutDialog(context);
                if(data) {
                  AuthSerivce.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<MenuOptions>(
                value: MenuOptions.logout,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(builder:(context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text('abvxssda');
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              }, stream: _notesService.allNotes,);
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
