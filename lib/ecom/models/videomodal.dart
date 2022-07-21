// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Model.dart';

class VideoModal extends Model {
  static const String UID = "uid";
  static const String PROFILE_IMAGE_URL = "profileImageUrl";
  static const String VIDEO_ID = "videoId";
  static const String LIKES = "likes";
  static const String COMMENT_COUNT = "commentCount";
  static const String SHARE_COUNT = "shareCount";
  static const String SONG_NAME = "songName";
  static const String CAPTION = "caption";
  static const String VIDEO_URL = "videoUrl";
  static const String PREVIEW_IMAGE = "previewImage";
  static const String TIME = "timestamp";
//  static const String REACTIONS = "receiver";
//  static const String PHONE_KEY = "phone";

  String? uid;
  String? profileImageUrl;
  String? videoId;
  dynamic likes;
  int? commentCount;
  int? shareCount;
  String? songName;
  String? caption;
  String? videoUrl;
  String? previewImage;
  Timestamp? time;
//  List<Reaction<String>>? reactions ;

  VideoModal(
      {String? id,
      this.uid,
      this.profileImageUrl,
      this.videoId,
      this.likes,
      this.commentCount,
      this.shareCount,
      this.songName,
      this.caption,
      this.videoUrl,
      this.previewImage,
      this.time
      //   this.reactions
      })
      : super(id);

  factory VideoModal.fromMap(Map<String, dynamic> map, {String? id}) {
    return VideoModal(
      id: id,
      uid: map[UID],
      profileImageUrl: map[PROFILE_IMAGE_URL],
      videoId: map[VIDEO_ID],
      likes: map[LIKES],
      commentCount: map[COMMENT_COUNT],
      shareCount: map[SHARE_COUNT],
      songName: map[SONG_NAME],
      caption: map[CAPTION],
      videoUrl: map[VIDEO_URL],
      previewImage: map[PREVIEW_IMAGE],
      time: map[TIME],
      //    reactions: map[REACTIONS],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      UID: uid,
      PROFILE_IMAGE_URL: profileImageUrl,
      VIDEO_ID: videoId,
      LIKES: likes,
      COMMENT_COUNT: commentCount,
      SHARE_COUNT: shareCount,
      SONG_NAME: songName,
      CAPTION: caption,
      VIDEO_URL: videoUrl,
      PREVIEW_IMAGE: previewImage,
      TIME: time,
      //   REACTIONS : reactions ,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (uid != null) map[UID] = uid;
    if (profileImageUrl != null) map[PROFILE_IMAGE_URL] = profileImageUrl;
    if (videoId != null) map[VIDEO_ID] = videoId;
    if (likes != null) map[LIKES] = likes;
    if (commentCount != null) map[COMMENT_COUNT] = commentCount;
    if (shareCount != null) map[SHARE_COUNT] = shareCount;
    if (songName != null) map[SONG_NAME] = songName;
    if (caption != null) map[CAPTION] = caption;
    if (videoUrl != null) map[VIDEO_URL] = videoUrl;
    if (previewImage != null) map[PREVIEW_IMAGE] = previewImage;
    if (time != null) map[TIME] = time;
    // if (reactions != null) map[REACTIONS] = reactions;

    return map;
  }
}
