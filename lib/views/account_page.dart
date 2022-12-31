//flutter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_vol2/constants/enums.dart';
import 'package:sns_vol2/constants/routes.dart' as routes;
import 'package:sns_vol2/constants/strings.dart';
import 'package:sns_vol2/details/normal_appbar.dart';
import 'package:sns_vol2/models/auth/account_model.dart';
import 'package:sns_vol2/models/main_model.dart';
import 'package:sns_vol2/constants/colors.dart' as colors;
class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key, required this.mainModel}) : super(key: key);
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountModel accountModel = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: colors.backScreenColor,
      appBar: const NormalAppBar(title: muteUsersPageTitle, boolValue: false,),
      body: ListView(
        children: [
          ListTile(
            title: const Text(updatePasswordText, style: TextStyle(color: colors.appBarTextColor),),
            trailing: const Icon(Icons.arrow_forward_ios, color: colors.appBarTextColor,),
            onTap: () {
              accountModel.reauthenticationState =
                  ReauthenticationState.updatePassword;
              routes.toReauthenticationPage(
                  context: context);
            },
          ),
          ListTile(
            title: Text('$updateEmailText \n ${accountModel.currentUser!.email!}', style: const TextStyle(color: colors.appBarTextColor),),
            trailing: const Icon(Icons.arrow_forward_ios, color: colors.appBarTextColor,),
            onTap: () {
              accountModel.reauthenticationState =
                  ReauthenticationState.updateEmail;
              routes.toReauthenticationPage(
                  context: context);
            },
          ),
          ListTile(
            title: const Text(logoutText, style: TextStyle(color: colors.appBarTextColor),),
            onTap: () async =>
                await mainModel.logout(context: context, mainModel: mainModel),
          ),
        ],
      ),
    );
  }
}
