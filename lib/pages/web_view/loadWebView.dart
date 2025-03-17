import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'loadDataAndTemplate.dart'; 
import 'package:makeitcode/widget/auth.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key); 
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final loadDataAndTemplate _dataAndTemplate = loadDataAndTemplate();
  String? _htmlContent;
  bool _isPhoneView = true;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _startLoad();
  }

  Future<void> _startLoad() async {
    String userId = Auth().uid!;
    await _dataAndTemplate.generateHTMLFromFirestore(userId, 'index.html', _isPhoneView);
    final filePath = await _dataAndTemplate.getHtmlFilePath('index.html');
    final file = File(filePath);
    String rawHtml = await file.readAsString();

    // Injecter la classe CSS appropriée (desktop ou mobile)
    String updatedHtml = rawHtml.replaceAll(
      '<body>',
      '<body class="${_isPhoneView ? 'mobile-view' : 'desktop-view'}">'
    );

    setState(() {
      _htmlContent = updatedHtml;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rendu de votre protfolio', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20) ),
        backgroundColor: Color.fromRGBO(0, 113, 152, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isPhoneView ? Icons.phone_android : Icons.desktop_windows),
            color: Colors.white,
            onPressed: () async {
              setState(() {
                _isPhoneView = !_isPhoneView;
              });
              await _startLoad();
              if (_webViewController != null) {
                _webViewController!.loadData(data: _htmlContent!, mimeType: 'text/html', encoding: 'utf-8');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _htmlContent != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InAppWebView(
                      initialData: InAppWebViewInitialData(
                        data: _htmlContent!,
                        mimeType: 'text/html',
                        encoding: 'utf-8',
                      ),
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
