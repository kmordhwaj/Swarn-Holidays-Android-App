// ignore_for_file: unnecessary_this

import 'dart:io';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';

class ViewPdf extends StatefulWidget {
  final File? file;
  const ViewPdf({Key? key, required this.file}) : super(key: key);

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  PDFDocument doc = PDFDocument();

  @override
  void initState() {
    super.initState();
    viewNow();
  }

  viewNow() async {
    final docX = await PDFDocument.fromFile(widget.file!);
    setState(() {
      this.doc = docX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pdf View')),
        body: PDFViewer(document: doc));
  }
}
