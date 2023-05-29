import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PreviewPage extends StatefulWidget {
  final fileId;
  const PreviewPage({Key? key, required this.fileId}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {

  bool _isLoading = true;
  PDFDocument? _document;
  final int _numPages = 8;
  File? file;

  Future<void> downloadFileFromAPI() async {
    final dio = Dio();
    final response = await dio.get(
      '${dotenv.env["URL"]}/api/v1/files/${widget.fileId}',
      options: Options(responseType: ResponseType.bytes),
    );
    file = File('/preview');
    await file!.writeAsBytes(response.data);
  }

  Future<void> deleteFile() async {
    if (await file!.exists()) {
      await file!.delete();
    }
  }

  Future<void> fetchPDF() async {
    await downloadFileFromAPI();
    final doc = await PDFDocument.fromFile(file!);
    setState(() {
      _document = doc;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPDF();
  }

  @override
  void dispose() {
    deleteFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : PageView.builder(
          itemCount: _numPages,
          itemBuilder: (context, index) {
            var pageNumber = index + 1;
            return FutureBuilder<PDFPage>(
              future: _document!.get(page: pageNumber),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Image.file(File(snapshot.data!.imgPath!)),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading page $pageNumber');
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
    );
  }
}
