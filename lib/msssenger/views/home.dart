// ignore_for_file: unnecessary_string_escapes

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageHome extends StatefulWidget {
  const MessageHome({Key? key}) : super(key: key);

  @override
  _MessageHomeState createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  bool isSearching = false;
  Stream<QuerySnapshot>? usersStream;
  TextEditingController searchController = TextEditingController();

  onSearchBtnClk(search) async {
    isSearching = true;
    setState(() {});
  }

  Widget searchListUserTile({
    required String profileUrl,
    required String firstname,
    required String secondname,
  }) {
    return Row(children: [
      CachedNetworkImage(
        imageUrl: profileUrl,
        height: 30,
        width: 30,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$firstname $secondname',
              style: const TextStyle(color: Colors.white)),
        ],
      )
    ]);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  Widget searchUsersList() {
    return StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return searchListUserTile(
                      profileUrl: ds['profileImageUrl'],
                      firstname: ds['firstName'],
                      secondname: ds['secondName'],
                    )
                        //  CachedNetworkImage(imageUrl: ds['profileImageUrl'])
                        ;
                  })
              : const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void initState() {
    super.initState();
    searchUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                        onTap: () {
                          isSearching = false;
                          searchController.text = '';
                          setState(() {});
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.arrow_back),
                        ))
                    : Container(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black54,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                        GestureDetector(
                            onTap: () {
                              if (searchController.text != '') {
                                onSearchBtnClk(searchController.text);
                              }
                            },
                            child: const Icon(Icons.search))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            searchUsersList()
          ],
        ),
      ),
    );
  }
}
