// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserUpdateLog _$$_UserUpdateLogFromJson(Map<String, dynamic> json) =>
    _$_UserUpdateLog(
      logCreatedAt: json['logCreatedAt'],
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
      introduction: json['introduction'] as String,
      userRef: json['userRef'],
      searchToken: json['searchToken'] as Map<String, dynamic>,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$_UserUpdateLogToJson(_$_UserUpdateLog instance) =>
    <String, dynamic>{
      'logCreatedAt': instance.logCreatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
      'introduction': instance.introduction,
      'userRef': instance.userRef,
      'searchToken': instance.searchToken,
      'uid': instance.uid,
    };
