import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  final File? photofile;
  const PhotoPreview({Key? key, required this.photofile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(photofile!), fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
