import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'firestore_user.freezed.dart';
part 'firestore_user.g.dart';
//jsonのデータがクラスになるファイルを生成

@freezed
abstract class FirestoreUser with _$FirestoreUser {
  //constは一定という意味
  const factory FirestoreUser({
    required dynamic createdAt,
    required dynamic updatedAt,
    //Freezedではパッケージの型が使えない＝FirestoreのTimestampなど。
    //dynamicで代用するが、エラーを吐いてくれない型だから、特殊な場面以外は非推奨

    required String email,
    required String userName,
    required String uid,
  }) = _FirestoreUser;

  factory FirestoreUser.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserFromJson(json);
}