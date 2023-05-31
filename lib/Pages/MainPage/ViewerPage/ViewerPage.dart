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
  const ViewerPage({Key? key, required this.book, required this.user}) : super(key: key);

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {

  File? file;

  @override
  void initState() {
    getBytesBook();
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
          file!
      ),
    );
  }
}
