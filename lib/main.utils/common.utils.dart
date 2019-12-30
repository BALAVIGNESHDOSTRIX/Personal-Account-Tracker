import 'package:flutter/material.dart';

class CommanUtils{

  void showSnackBars(BuildContext context, String message) {
		var snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}
}