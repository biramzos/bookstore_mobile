import 'dart:io';
import 'dart:typed_data';

import 'package:Bookstore/Model/Book.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class PreviewPage extends StatefulWidget {
  final Book book;
  final User user;
  const PreviewPage({Key? key, required this.book, required this.user}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late PdfViewerController _pdfViewerController;
  File? file;

  @override
  void initState() {
    //createFileFromBytes();
    getBytesBook();
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  Future<void> getBytesBook() async{
    var url = Uri.parse('${dotenv.env['URL']}/api/v1/files/${widget.book.id}');
    var response = await http.get(
        url,
        headers: {
          "Authorization":"Bearer ${widget.user.token}"
        }
    );
    var dir = await getApplicationDocumentsDirectory();
    setState((){
      file = new File("${dir.path}/data.pdf");
      file!.writeAsBytesSync(response.bodyBytes, flush: true);
    });
  }

  @override
  void dispose() {
    file = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(file == null){
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              'assets/images/loader.gif',
              width: 200,
              height: 200,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('QazaqBooks'),
        backgroundColor: Colors.green,
      ),
      body: SfPdfViewer.file(
          file!,
        onPageChanged: (PdfPageChangedDetails details) {
          if (details.newPageNumber >= 9) {
            _pdfViewerController.jumpToPage(8); // Limit to the first 8 pages
          }
        },
        controller: _pdfViewerController,
      ),
    );
  }
}
