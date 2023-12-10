import 'dart:io';

import 'package:Bookstore/Model/Book.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class ViewerPage extends StatefulWidget {
  final Book book;
  final User user;
  final bool isPreview;
  const ViewerPage({Key? key, required this.book, required this.user, required this.isPreview}) : super(key: key);

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  late PdfViewerController _pdfViewerController;
  File? file;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    getBytesBook();
    super.initState();
  }

  Future<void> getBytesBook() async{
    var url = Uri.parse('${dotenv.env['URL']}/api/v1/files/${widget.book.file!.id}');
    var response = await http.get(
        url,
        headers: {
          "Authorization":"Bearer ${widget.user.token}"
        }
    );
    var dir = await getApplicationDocumentsDirectory();
    setState((){
      file = File("${dir.path}/${widget.book.file!.name}");
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
        appBar: AppBar(
          title: const Text('QazaqBooks'),
          backgroundColor: Colors.green,
        ),
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
          if (widget.isPreview) {
            if (details.newPageNumber >= 9) {
              _pdfViewerController.jumpToPage(8); // Limit to the first 8 pages
            }
          } // Else no limitation!
        },
        controller: _pdfViewerController,
      ),
    );
  }
}
