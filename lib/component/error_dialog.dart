import 'package:flutter/material.dart';

Future<bool> showErrorDialog(BuildContext context, {
  String title  =  'Error', 
  String message = 'An error has occurred',
  String buttonTextConfirm = 'Ok',
  onConfirm,
  String buttonTextReject = 'Cancel',
  onReject,
}) {
  final _onConfirmFunction = onConfirm  ?? () {
        Navigator.of(context).pop(false);
      };
  final _onRejectFunction = onReject ?? () {
      Navigator.of(context).pop(true);
  };
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(buttonTextConfirm),
            onPressed: _onConfirmFunction,
          ),
          TextButton(
            child:  Text(buttonTextReject),
            onPressed: _onRejectFunction,
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
