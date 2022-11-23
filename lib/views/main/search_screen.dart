//flutter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_vol2/constants/strings.dart';
import 'package:sns_vol2/domain/firestore_user/firestore_user.dart';
import 'package:sns_vol2/models/main/search_model.dart';
import 'package:sns_vol2/constants/routes.dart' as routes;

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key, required FirestoreUser passiveUser})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SearchModel searchModel = ref.watch(searchProvider);
    final FirestoreUser passiveUser;

    return ListView.builder(
        itemCount: searchModel.users.length,
        itemBuilder: (context, index) {
          //usersの配列から１つ１つを取得している
          final FirestoreUser firestoreUser = searchModel.users[index];
          return ListTile(
            title: Text(firestoreUser.uid),
            onTap: () => routes.toPassiveUserProfilePagepPage(
                context: context, passiveUser: firestoreUser),
          );
        });
  }
}
