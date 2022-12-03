import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//packages
import 'package:flash/flash.dart';
import 'package:sns_vol2/domain/post/post.dart';
import 'package:sns_vol2/models/main_model.dart';
import 'package:sns_vol2/constants/routes.dart' as routes;

void showFlashBar({
  required BuildContext context,
  required MainModel mainModel,
  required TextEditingController textEditingController,
  required void Function(String)? onchanged,
  required String titleString,
  required Color positiveActionColor,
  required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? primaryActionBuilder,
}) {
  context.showFlashBar(
    content: Form(
      child: TextFormField(
        controller: textEditingController,
        style: const TextStyle(fontWeight: FontWeight.bold),
        onChanged: onchanged,
        maxLength: 10,
      ),
    ),
    title: Text(titleString),
    primaryActionBuilder: primaryActionBuilder,
    negativeActionBuilder: (context, controller, _) {
      return InkWell(
        child: const Icon(Icons.close),
        onTap: () async => await controller.dismiss(),
      );
    },
  );
}
