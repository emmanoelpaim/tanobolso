import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class TermScreen extends StatefulWidget {
  TermScreen({Key key, this.auth, this.userId, this.logoutCallback,this.urlTerm})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String urlTerm;

  @override
  State<StatefulWidget> createState() => new _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  String tempFile = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
    super.initState();
  }

  void downloadFile() async {
    if (tempFile == "" && widget.urlTerm != "") {
      final dio = Dio();
      dio.options.connectTimeout = 15000;
      tempFile = (await getTemporaryDirectory()).path;
      setState(() {
        tempFile = tempFile+'/term.pdf';
      });

      var file = await dio.download(widget.urlTerm, tempFile);
      print(file.statusMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    downloadFile();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Termos de Uso"),
      ),
      body: getPDFLayout()
    );
  }

  Widget getPDFLayout() {
    return tempFile != "" ? FileReaderView(filePath: tempFile) : Text("Carregando ...");
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
