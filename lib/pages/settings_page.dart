import 'package:chat_app/components/my_settings_list_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocked_users_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void userWantsToDeleteAccount(BuildContext context) async {
    bool confirm = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content:
                  const Text('Are you sure you want to delete your account?'),
              actions: [
                // cancel button
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    // if the user confirmed the proceed deletion
    if (confirm) {
      try {
        // delete the user from the database
        Navigator.pop(context);
        await AuthService().deleteAccount();
      } catch (e) {
        // handle the error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Setttings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              //dark mode button
              MySettingsListTile(
                textColor: Theme.of(context).colorScheme.inversePrimary,
                title: "Dark Mode",
                action: CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
              //blocked users button
              MySettingsListTile(
                textColor: Theme.of(context).colorScheme.inversePrimary,
                title: "Blocked Users",
                action: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedUsersPage(),
                      )),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),

              //delete button
              MySettingsListTile(
                title: "Delete Account",
                action: IconButton(
                  onPressed: () => userWantsToDeleteAccount(context),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                color: Colors.red,
                textColor: Theme.of(context).colorScheme.tertiary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
