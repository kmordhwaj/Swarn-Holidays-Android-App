import 'dart:io';
import 'package:new_swarn_holidays/ecom/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:new_swarn_holidays/ecom/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String>? choseImageFromLocalFiles(
  BuildContext context, {
  int maxSizeInKB = 5120,
  int minSizeInKB = 5,
}) async {
  final PermissionStatus photoPermissionStatus =
      await Permission.photos.request();
  if (!photoPermissionStatus.isGranted) {
    throw LocalFileHandlingStorageReadPermissionDeniedException(
        message: "Permission required to read storage, please give permission");
  }

  final imgPicker = ImagePicker();
  final imgSource = await showDialog(
    builder: (context) {
      return AlertDialog(
        title: const Text("Chose image source"),
        actions: [
          TextButton(
            child: const Text("Camera"),
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          TextButton(
            child: const Text("Gallery"),
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      );
    },
    context: context,
  );
  if (imgSource == null) {
    throw LocalImagePickingInvalidImageException(
        message: "No image source selected");
  }
  final XFile? imagePicked = await imgPicker.pickImage(
    source: imgSource,
  );
  if (imagePicked == null) {
    throw LocalImagePickingInvalidImageException();
  } else {
    final fileLength = await File(imagePicked.path).length();
    if (fileLength > (maxSizeInKB * 1024) ||
        fileLength < (minSizeInKB * 1024)) {
      throw LocalImagePickingFileSizeOutOfBoundsException(
          message: "Image size should not exceed 5MB");
    } else {
      return imagePicked.path;
    }
  }
}
