import 'package:flutter/material.dart';

import '../style.dart' as style;


class FailDialog extends StatelessWidget {
  const FailDialog({Key? key, this.failContent}) : super(key: key);
  final failContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(failContent, style: style.normalTextDark),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(
          onPressed: (){Navigator.pop(context);},
          style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
          child: Text('닫기', style: style.dialogCheckText),
        )
      ],
    );
  }
}

void showSnackBar(BuildContext context, result) {
  final snackBar = SnackBar(
    duration: Duration(milliseconds: 1000),
    content: Text(result, textAlign: TextAlign.center, style: style.normalText),
    backgroundColor: Colors.black.withOpacity(0.8),
    behavior: SnackBarBehavior.floating,
    shape: StadiumBorder(),
    width: result.length < 5 ? 100 : result.length < 10 ? 200 : 300,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}