// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';

class PostModal extends Model {
  static const String POST_ID = "postId";
  static const String OWNER_ID = "ownerId";
  static const String LOCATION = "location";
  static const String DESCRIPTION = "description";
  // static const String LIKES = "likes";
  static const String MEDIA_URL = "mediaUrl";
  static const String TIME = "timestamp";
  static const String PRODUCT_ID = 'productId';
  // static const String COMMENTS = 'comments';

  String? postId;
  String? ownerId;
  String? location;
  String? description;
  String? productId;
  String? mediaUrl;
  Timestamp? time;

  PostModal({
    String? id,
    this.postId,
    this.ownerId,
    this.location,
    this.description,
    this.mediaUrl,
    this.productId,
    this.time,
  }) : super(id);

  factory PostModal.fromMap(Map<String, dynamic> map, {String? id}) {
    return PostModal(
        id: id,
        postId: map[POST_ID],
        ownerId: map[OWNER_ID],
        location: map[LOCATION],
        description: map[DESCRIPTION],
        mediaUrl: map[MEDIA_URL],
        time: map[TIME],
        productId: map[PRODUCT_ID]);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      POST_ID: postId,
      OWNER_ID: ownerId,
      LOCATION: location,
      DESCRIPTION: description,
      MEDIA_URL: mediaUrl,
      TIME: time,
      PRODUCT_ID: productId
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (postId != null) map[POST_ID] = postId;
    if (ownerId != null) map[OWNER_ID] = ownerId;
    if (location != null) map[LOCATION] = location;
    if (description != null) map[DESCRIPTION] = description;
    if (mediaUrl != null) map[MEDIA_URL] = mediaUrl;
    if (productId != null) map[PRODUCT_ID] = productId;
    if (time != null) map[TIME] = time;

    return map;
  }
}
