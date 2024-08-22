import 'package:chat_app/components/my_drawer_tile.dart';
import 'package:flutter/material.dart';

import '../pages/settings_page.dart';
import '../services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();
    // then naviaget to intila route;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 100,
                  ),
                ),
              ),

              //home list tile
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                ),
                child: MyDrawerTile(
                  title: 'H O M E',
                  leading: Icons.home,
                  onTap: () => Navigator.pop(context),
                ),
              ),

              //settings list tile
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                ),
                child: MyDrawerTile(
                  title: 'S E T T I N G S',
                  leading: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
            ),
            child: MyDrawerTile(
              title: 'L O G O U T',
              leading: Icons.logout,
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
