import 'package:flutter/widgets.dart';
import 'package:personalnotesapp/utilities/dialogs/generic_dialogs.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'log out',
    content: 'are you sure you wnat to log out ?',
    optionsBuilder: () => {
      'cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false,
  );
}
