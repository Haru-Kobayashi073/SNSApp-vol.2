//flutter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_vol2/constants/strings.dart';
import 'package:sns_vol2/details/rounded_button.dart';
import 'package:sns_vol2/details/user_image.dart';
import 'package:sns_vol2/models/main/profile_model.dart';
import 'package:sns_vol2/models/main_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key, required this.mainModel}) : super(key: key);
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileModel profileModel = ref.watch(profileProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      profileModel.croppedFile == null
          ? Container(
              alignment: Alignment.center,
              child: UserImage(
                length: 100,
                userImageURL: mainModel.firestoreUser.userImageURL,
              ),
            )
            :ClipRRect(
          borderRadius: BorderRadius.circular(300.0),
          child: Image.file(profileModel.croppedFile!),
        ),
          // : CircleAvatar(
          //   radius: 160,
          //   child: Image.file(
          //     profileModel.croppedFile!)),
      RoundedButton(
          onPressed: () async => await profileModel.uploadUserImage(currentUserDoc: mainModel.currentUserDoc),
            widthRate: 0.4,
            color: Colors.blue,
            text: 'Upload')
    ]);
  }
}