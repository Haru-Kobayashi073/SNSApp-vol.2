import 'package:flutter/material.dart';
import 'package:sns_vol2/models/mute_user_model.dart';

class CardPopupMenuButton extends StatelessWidget {
  const CardPopupMenuButton({super.key, required this.muteUserModel, required this.onSelected});
  final MuteUserModel muteUserModel;
  final void Function(String)? onSelected;
  // final  selectedValue

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: '0',
          child: Text('ユーザーをミュート'),
        ),
      ],
    );
  }
}
