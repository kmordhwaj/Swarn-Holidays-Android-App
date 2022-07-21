// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';

class CommentModal extends Model {
  static const String COMMENT_ID = "commentId";
  static const String OWNER_ID = "ownerId";
  static const String DESCRIPTION = "description";
  // static const String LIKES = "likes";
  // static const String REPLIES = 'replies';
  static const String MEDIA_URL = "mediaUrl";
  static const String TIME = "timestamp";

  String? commentId;
  String? ownerId;
  String? description;
  String? mediaUrl;
  // Map<dynamic, dynamic>? likes;
//  Map<dynamic, dynamic>? replies;
  Timestamp? time;

  CommentModal({
    String? id,
    this.commentId,
    this.ownerId,
    this.description,
    this.mediaUrl,
    //   this.likes,
    //  this.replies,
    this.time,
  }) : super(id);

  factory CommentModal.fromMap(Map<String, dynamic> map, {String? id}) {
    return CommentModal(
      id: id,
      commentId: map[COMMENT_ID],
      ownerId: map[OWNER_ID],
      description: map[DESCRIPTION],
      mediaUrl: map[MEDIA_URL],
      //    likes: map[LIKES],
      //   replies: map[REPLIES],
      time: map[TIME],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      COMMENT_ID: commentId,
      OWNER_ID: ownerId,
      DESCRIPTION: description,
      MEDIA_URL: mediaUrl,
      //    LIKES: likes,
      //   REPLIES: replies,
      TIME: time,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (commentId != null) map[COMMENT_ID] = commentId;
    if (ownerId != null) map[OWNER_ID] = ownerId;
    if (description != null) map[DESCRIPTION] = description;
    if (mediaUrl != null) map[MEDIA_URL] = mediaUrl;
    //   if (likes != null) map[LIKES] = likes;
    //   if (replies != null) map[REPLIES] = replies;
    if (time != null) map[TIME] = time;

    return map;
  }
}
