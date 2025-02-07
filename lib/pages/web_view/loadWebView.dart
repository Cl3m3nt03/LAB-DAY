import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'loadDataAndTemplate.dart'; 

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key); 
  @override
  _WebViewPageState createState() => _WebViewPageState();
}
class _WebViewPageState extends State<WebViewPage> {
  final loadDataAndTemplate _dataAndTemplate = loadDataAndTemplate();
  // Variable pour stocker le contenu HTML non initialisé
  String? _htmlContent;

  @override
  void initState() {
    super.initState();
    _startLoad();
  }

  Future<void> _startLoad() async {

    // UserId fix pour les tests ATTENTION à modifier
    String userId = "test"; 
    await _dataAndTemplate.generateHTMLFromFirestore(userId, 'index.html');
    // Récupère le contenu HTML généré
    final filePath = await _dataAndTemplate.getHtmlFilePath('index.html');
    final file = File(filePath);
    // Charge le contenu HTML du fichier du téléphone dans la variable _htmlContent
    _htmlContent = await file.readAsString();

    // Permet de rafrachir la page
    setState(() {}); 
  }

  @override
  // Dispose permet de libérer les ressources utilisées par le widget
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebView Local'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      
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
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
