import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  String? id;
  String? firstName;
  String? secondName;
  String? profileImageUrl;
  String? coverImageUrl;
  String? email;
  String? bio;
  String? college;
  String? school;
  String? job;
  String? token;
  bool? isBanned;
  // final List<String> favoritePosts;
  // final List<String> blockedUsers;
  // final List<String> hideStoryFromUsers;
  // final List<String> closeFriends;
  // final bool allowStoryMessageReplies;
  String? role;
  bool? isVerified;
  String? website;
  Timestamp? timeCreated;
  String? dob;
  String? phone;
  List<String>? favouriteProducts;
  int level;

  UserModal(
      {this.id,
      this.firstName,
      this.secondName,
      this.profileImageUrl,
      this.coverImageUrl,
      this.email,
      this.bio,
      this.job,
      this.token,
      this.isBanned,
      this.isVerified,
      this.website,
      this.role,
      this.timeCreated,
      this.dob,
      this.phone,
      this.favouriteProducts,
      this.college,
      this.school,
      this.level = 1});

  //receive data from server
  factory UserModal.fromDocument(
      // DocumentSnapshot
      doc) {
    return UserModal(
        id: doc['id'],
        firstName: doc['firstName'],
        secondName: doc['secondName'],
        profileImageUrl: doc['profileImageUrl'],
        coverImageUrl: doc['coverImageUrl'],
        email: doc['email'],
        bio: doc['bio'],
        job: doc['job'],
        token: doc['token'],
        isVerified: doc['isVerified'],
        isBanned: doc['isBanned'],
        website: doc['website'],
        role: doc['role'],
        timeCreated: doc['timeCreated'],
        dob: doc['dob'],
        phone: doc['phone'],
        favouriteProducts: doc['favourite_products'],
        college: doc['college'],
        school: doc['school'],
        level: doc['level']);
  }

  //recieve data from server
  factory UserModal.fromMap(
      //Map<String, dynamic>
      map) {
    return UserModal(
        id: map['id'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        profileImageUrl: map['profileImageUrl'],
        coverImageUrl: map['coverImageUrl'],
        email: map['email'],
        bio: map['bio'],
        job: map['job'],
        token: map['token'],
        isVerified: map['isVerified'],
        isBanned: map['isBanned'],
        website: map['website'],
        role: map['role'],
        timeCreated: map['timeCreated'],
        dob: map['dob'],
        phone: map['phone'],
        favouriteProducts: map['favourite_products'],
        college: map['college'],
        school: map['school'],
        level: map['level']);
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'secondName': secondName,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'email': email,
      'bio': bio,
      'job': job,
      'token': token,
      'isVerified': isVerified,
      'isBanned': isBanned,
      'website': website,
      'role': role,
      'timeCreated': timeCreated,
      'dob': dob,
      'phone': phone,
      'favourite_products': favouriteProducts,
      'school': school,
      'college': college,
      'level': level
    };
  }
}
