import 'package:flutter/material.dart';

import 'components/body.dart';

class SearchResultScreen1 extends StatelessWidget {
  final String searchQuery;
  final String searchIn;
  final List<String?>? searchResultUsersId;

  const SearchResultScreen1({
    Key? key,
    required this.searchQuery,
    required this.searchResultUsersId,
    required this.searchIn,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(
        searchQuery: searchQuery,
        searchResultUsersId: searchResultUsersId,
        searchIn: searchIn,
      ),
    );
  }
}