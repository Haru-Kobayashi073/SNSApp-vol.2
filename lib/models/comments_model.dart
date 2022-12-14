//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
//packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sns_vol2/constants/enums.dart';
import 'package:sns_vol2/constants/lists.dart';
import 'package:sns_vol2/constants/others.dart';
import 'package:sns_vol2/constants/strings.dart';
import 'package:sns_vol2/constants/voids.dart' as voids;
import 'package:sns_vol2/domain/comment/comment.dart';
import 'package:sns_vol2/domain/comment_like/comment_like.dart';
import 'package:sns_vol2/domain/firestore_user/firestore_user.dart';
import 'package:sns_vol2/domain/like_comment_token/like_comment_token.dart';
import 'package:sns_vol2/domain/post/post.dart';
import 'package:sns_vol2/models/main_model.dart';
import 'package:sns_vol2/constants/routes.dart' as routes;
import 'package:sns_vol2/models/mute_users_model.dart';

final commentsProvider = ChangeNotifierProvider((ref) => CommentsModel());

class CommentsModel extends ChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  String commentString = "";
  //投稿ごとにリフレッシュできる必要があるから、毎回情報を捨てる必要がある
  RefreshController refreshController = RefreshController();
  List<DocumentSnapshot<Map<String, dynamic>>> commentDocs = [];
  List<String> muteUids = [];
  Query<Map<String, dynamic>> returnQuery(
      {required DocumentSnapshot<Map<String, dynamic>> postDoc}) {
    //postに紐づくコメントが欲しい
    return postDoc.reference
        .collection('postComments')
        .orderBy('likeCount', descending: true);
  }

  //同じデータを無駄に取得しないようにする
  String indexPostCommentId = '';

  CommentsModel() {
    ///muteUidsを読み込むのは一回だけでいい
    init();
  }

  Future<void> init() async {
    final muteUidsAndMutePostIds = await returnMuteUidsAndMutePostIds();
    muteUids = muteUidsAndMutePostIds.first;
  }

  //コメントボタンが押された時の処理
  Future<void> onCommentButtonPressed(
      {required DocumentSnapshot<Map<String, dynamic>> postDoc,
      required BuildContext context,
      required Post post,
      required MainModel mainModel,
      required MuteUsersModel muteUserModel}) async {
    refreshController = RefreshController();
    routes.toCommentsPage(
        context: context,
        post: post,
        mainModel: mainModel,
        postDoc: postDoc,
        muteUserModel: muteUserModel);
    if (indexPostCommentId != post.postId) {
      await onReload(postDoc: postDoc);
    }
    indexPostCommentId = post.postId;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh(
      {required DocumentSnapshot<Map<String, dynamic>> postDoc}) async {
    refreshController.refreshCompleted();
    // if (commentDocs.isNotEmpty) {
    //   final qshot = await returnQuery(postDoc: postDoc)
    //       .endBeforeDocument(commentDocs.first)
    //       .get();
    //   final reversed = qshot.docs.reversed.toList();
    //   for (final commentDoc in reversed) {
    //     commentDocs.insert(0, postDoc);
    //   }
    // }
    await voids.processNewDocs(
        docs: commentDocs,
        query: returnQuery(postDoc: postDoc),
        mutePostIds: [],
        muteUids: muteUids);
    notifyListeners();
  }

  Future<void> onReload({
    required DocumentSnapshot<Map<String, dynamic>> postDoc,
  }) async {
    commentDocs = [];
    await voids.processBasicDocs(
        docs: commentDocs,
        query: returnQuery(postDoc: postDoc),
        mutePostIds: [],
        muteUids: muteUids);
    notifyListeners();
  }

  Future<void> onLoading({
    required DocumentSnapshot<Map<String, dynamic>> postDoc,
  }) async {
    refreshController.loadComplete();
    await voids.processOldDocs(
        docs: commentDocs,
        query: returnQuery(postDoc: postDoc),
        mutePostIds: [],
        muteUids: muteUids);
    notifyListeners();
  }

  void showCommentFlashBar({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String, dynamic>> postDoc,
  }) {
    voids.showFlashBar(
        context: context,
        mainModel: mainModel,
        textEditingController: textEditingController,
        onchanged: (value) => commentString = value,
        titleString: createCommentText,
        positiveActionColor: Colors.black,
        primaryActionBuilder: (_, controller, __) {
          return InkWell(
            child: Icon(Icons.send),
            onTap: () async {
              if (textEditingController.text.isNotEmpty) {
                //メインの動作
                await createComment(
                    currentUserDoc: mainModel.currentUserDoc,
                    firestoreUser: mainModel.firestoreUser,
                    postDoc: postDoc);
                await controller.dismiss();
                commentString = "";
                textEditingController.text = "";
              } else {
                //何もしない
                await controller.dismiss();
              }
            },
          );
        });
  }

  Future<void> createComment(
      {required DocumentSnapshot<Map<String, dynamic>> currentUserDoc,
      required FirestoreUser firestoreUser,
      required DocumentSnapshot<Map<String, dynamic>> postDoc}) async {
    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String postCommentId = returnUuidV4();
    final Comment comment = Comment(
        createdAt: now,
        updatedAt: now,
        comment: commentString,
        commentLanguageCode: "",
        commentNegativeScore: 0,
        commentPositiveScore: 0,
        commentSentiment: "",
        likeCount: 0,
        muteCount: 0,
        reportCount: 0,
        postRef: postDoc.reference,
        postCommentId: postCommentId,
        postCommentReplyCount: 0,
        userName: firestoreUser.userName,
        userNameLanguageCode: firestoreUser.userNameLanguageCode,
        userNameNegativeScore: firestoreUser.userNameNegativeScore,
        userNamePositiveScore: firestoreUser.userNamePositiveScore,
        userNameSentiment: firestoreUser.userNameSentiment,
        uid: activeUid,
        userImageURL: firestoreUser.userImageURL);
    await postDoc.reference
        .collection('postComments')
        .doc(postCommentId)
        .set(comment.toJson());
  }

  Future<void> like(
      {required Comment comment,
      required MainModel mainModel,
      required Post post,
      required DocumentSnapshot<Map<String, dynamic>> commentDoc}) async {
    //setting
    final String postCommentId = comment.postCommentId;
    mainModel.likeCommentIds.add(postCommentId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String tokenId = returnUuidV4();
    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String passiveUid = post.uid;
    //自分がコメントにいいねしたことの印
    final LikeCommentToken likeCommentToken = LikeCommentToken(
        activeUid: activeUid,
        passiveUid: passiveUid,
        createdAt: now,
        postCommentId: postCommentId,
        tokenId: tokenId,
        postCommentRef: commentDoc.reference,
        tokenType: likeCommentTokenTypeString);
    mainModel.likeCommentTokens.add(likeCommentToken);
    notifyListeners();
    await currentUserDoc.reference
        .collection('tokens')
        .doc(tokenId)
        .set(likeCommentToken.toJson());
    //コメントにいいねがついたことの印
    final CommentLike commentLike = CommentLike(
        activeUid: activeUid,
        createdAt: now,
        postCommentCreatorUid: comment.uid,
        postCommentRef: commentDoc.reference,
        postCommentId: postCommentId);
    await commentDoc.reference
        .collection('postCommentLikes')
        .doc(activeUid)
        .set(commentLike.toJson());
  }

  Future<void> unlike(
      {required Comment comment,
      required MainModel mainModel,
      required Post post,
      required DocumentSnapshot<Map<String, dynamic>> commentDoc}) async {
    final String postCommentId = comment.postCommentId;
    mainModel.likeCommentIds.remove(postCommentId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;

    //自分がいいねしたことの印を削除
    final deleteLikeCommentToken = mainModel.likeCommentTokens
        .where((element) => element.postCommentId == postCommentId)
        .toList()
        .first;
    mainModel.likeCommentTokens.remove(deleteLikeCommentToken);
    notifyListeners();
    await userDocToTokenDocRef(
            userDoc: currentUserDoc, tokenId: deleteLikeCommentToken.tokenId)
        .delete();
    final DocumentReference<Map<String, dynamic>> postCommentRef =
        deleteLikeCommentToken.postCommentRef;
    await postCommentRef.collection('postCommentLikes').doc(activeUid).delete();
  }

  void reportComment() {}
}
