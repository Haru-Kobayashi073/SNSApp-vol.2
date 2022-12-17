import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sns_vol2/constants/routes.dart' as routes;
import 'package:sns_vol2/constants/strings.dart';
import 'package:sns_vol2/main.dart';
import 'package:sns_vol2/models/main_model.dart';
import 'package:sns_vol2/models/themes_model.dart';

class SNSDrawer extends StatelessWidget {
  const SNSDrawer({Key? key, required this.mainModel, required this.themeModel})
      : super(key: key);
  final MainModel mainModel;
  final ThemeModel themeModel;
  

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text(accountTitle),
          onTap: () =>
              routes.toAccountPage(context: context, mainModel: mainModel),
        ),
        ListTile(
          title: const Text(themeTitle),
          trailing: CupertinoSwitch(
            value: themeModel.isDarkTheme,
            onChanged: (value) => themeModel.setIsDarkTheme(value: value),
          ),
        ),
        ListTile(
          title: const Text(muteUsersPageTitle),
          onTap: () =>
              routes.toMuteUsersPage(context: context, mainModel: mainModel),
        ),
        ListTile(
          title: const Text(muteCommentsPageTitle),
          onTap: () =>
              routes.toMuteCommentsPage(context: context, mainModel: mainModel)
        ),
        ListTile(
          title: const Text(mutePostsPageTitle),
          onTap: () =>
              routes.toMutePostsPage(context: context, mainModel: mainModel)
        ),
        if (mainModel.firestoreUser.isAdmin)
          ListTile(
            title: const Text(adminTitle),
            onTap: () =>
                routes.toAdminPage(context: context, mainModel: mainModel),
          )
      ],
    );
  }
}
