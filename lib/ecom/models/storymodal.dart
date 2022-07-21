// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Model.dart';

class StoryModal extends Model {
  static const String UID = "uid";
  static const String PROFILE_IMAGE_URL = "profileImageUrl";
  static const String STORY_ID = "storyId";
  static const String LIKES = "likes";
  static const String COMMENT_COUNT = "commentCount";
  static const String SHARE_COUNT = "shareCount";
  // static const String SONG_NAME = "songName";
  static const String CAPTION = "caption";
  static const String LOCATION = "location";
  static const String MEDIA_URL = "mediaUrl";
  static const String PREVIEW_IMAGE = "previewImage";
  static const String TIME = "timestamp";
  static const String TIME_END = "timeEnd";
  static const String VIEWS = 'views';
  static const String LINK_URL = "linkUrl";
  static const String DURATION = "duration";
  static const String FILTER = 'filter';
//  static const String REACTIONS = "receiver";
//  static const String PHONE_KEY = "phone";

  String? uid;
  String? profileImageUrl;
  String? storyId;
  dynamic likes;
  Map<dynamic, dynamic>? views;
  int? commentCount;
  int? shareCount;
  // String? songName;
  String? caption;
  String? location;
  String? mediaUrl;
  String? previewImage;
  Timestamp? time;
  Timestamp? timeEnd;
  String? linkUrl;
  int? duration;
  String? filter;

//  List<Reaction<String>>? reactions ;

  StoryModal(
      {String? id,
      this.uid,
      this.profileImageUrl,
      this.storyId,
      this.likes,
      this.views,
      this.commentCount,
      this.shareCount,
      // this.songName,
      this.caption,
      this.location,
      this.mediaUrl,
      this.previewImage,
      this.time,
      this.timeEnd,
      this.linkUrl,
      this.duration,
      this.filter
      //   this.reactions
      })
      : super(id);

  factory StoryModal.fromMap(Map<String, dynamic> map, {String? id}) {
    return StoryModal(
        id: id,
        uid: map[UID],
        profileImageUrl: map[PROFILE_IMAGE_URL],
        storyId: map[STORY_ID],
        likes: map[LIKES],
        views: map[VIEWS],
        commentCount: map[COMMENT_COUNT],
        shareCount: map[SHARE_COUNT],
        // songName: map[SONG_NAME],
        caption: map[CAPTION],
        location: map[LOCATION],
        mediaUrl: map[MEDIA_URL],
        previewImage: map[PREVIEW_IMAGE],
        time: map[TIME],
        timeEnd: map[TIME_END],
        linkUrl: map[LINK_URL],
        duration: map[DURATION],
        filter: map[FILTER]
        //    reactions: map[REACTIONS],
        );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      UID: uid,
      PROFILE_IMAGE_URL: profileImageUrl,
      STORY_ID: storyId,
      LIKES: likes,
      VIEWS: views,
      COMMENT_COUNT: commentCount,
      SHARE_COUNT: shareCount,
      // SONG_NAME: songName,
      CAPTION: caption,
      LOCATION: location,
      MEDIA_URL: mediaUrl,
      PREVIEW_IMAGE: previewImage,
      TIME: time,
      TIME_END: timeEnd,
      LINK_URL: linkUrl,
      DURATION: duration,
      FILTER: filter
      //   REACTIONS : reactions ,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (uid != null) map[UID] = uid;
    if (profileImageUrl != null) map[PROFILE_IMAGE_URL] = profileImageUrl;
    if (storyId != null) map[STORY_ID] = storyId;
    if (likes != null) map[LIKES] = likes;
    if (views != null) map[VIEWS] = views;
    if (commentCount != null) map[COMMENT_COUNT] = commentCount;
    if (shareCount != null) map[SHARE_COUNT] = shareCount;
    //  if (songName != null) map[SONG_NAME] = songName;
    if (caption != null) map[CAPTION] = caption;
    if (location != null) map[LOCATION] = location;
    if (mediaUrl != null) map[MEDIA_URL] = mediaUrl;
    if (previewImage != null) map[PREVIEW_IMAGE] = previewImage;
    if (time != null) map[TIME] = time;
    if (timeEnd != null) map[TIME_END] = timeEnd;
    if (linkUrl != null) map[LINK_URL] = linkUrl;
    if (duration != null) map[DURATION] = duration;
    if (filter != null) map[FILTER] = filter;
    // if (reactions != null) map[REACTIONS] = reactions;

    return map;
  }
}
