import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPlay extends StatelessWidget {
  final String photofile;
  const PhotoPlay({Key? key, required this.photofile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.green,
            backgroundColor: Colors.transparent),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.97,
              child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(photofile)),
            ),
          ),
        ));
  }
}
