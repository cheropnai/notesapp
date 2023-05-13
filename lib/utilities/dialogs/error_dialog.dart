import 'package:flutter/material.dart';
import 'package:personalnotesapp/utilities/dialogs/generic_dialogs.dart';

Future<void> showErrorDialog(BuildContext context, String text) async {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder:() => {
      'Ok': null,
    },
  );
}
