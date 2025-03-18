import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loadDataAndTemplate {

  Future<String> getHtmlFilePath(String templateName) async {
    final Directory? dir = await getExternalStorageDirectory();
    if (dir == null) {
      throw Exception("External storage directory not found");
    }
    return '${dir.path}/$templateName';
  }

Future<void> generateHTMLFromFirestore(String userId, String templateName, bool _isPhoneView) async {
  Map<String, dynamic> userData = await _getUserDataFromFirestore(userId);

  String htmlContent = await _loadHtmlTemplate(templateName);

  String cssContent = await _loadCss(userData['css'], _isPhoneView);

  htmlContent = _replaceData(htmlContent, userData, cssContent);

  final filePath = await getHtmlFilePath(templateName);
  final file = File(filePath);
  await file.writeAsString(htmlContent);
}

  Future<String> _loadCss(themeCss, bool isPhoneView) async {
    String cssContent;
    if (isPhoneView) {
      cssContent = await rootBundle.loadString('assets/project_template/portfolio/$themeCss-phone.css');
    } else {
      cssContent = await rootBundle.loadString('assets/project_template/portfolio/$themeCss.css');
    }
    return cssContent;
}

  Future<String> _loadHtmlTemplate(templateName) async {
    final String htmlTemplate = await rootBundle.loadString('assets/project_template/portfolio/$templateName');
    return htmlTemplate;
  }

String _replaceData(String htmlContent, Map<String, dynamic> userData, String cssContent) {
  htmlContent = htmlContent.replaceAll('{{title}}', userData['title']);
  htmlContent = htmlContent.replaceAll('{{about}}', userData['about']);
  htmlContent = htmlContent.replaceAll('{{email}}', userData['email']);
  htmlContent = htmlContent.replaceAll('{{phone}}', userData['phone']);
  htmlContent = htmlContent.replaceAll('{{skill1}}', userData['skill1']);
  htmlContent = htmlContent.replaceAll('{{skill2}}', userData['skill2']);
  htmlContent = htmlContent.replaceAll('{{project1}}', userData['project1']);
  htmlContent = htmlContent.replaceAll('{{project2}}', userData['project2']);
  htmlContent = htmlContent.replaceAll('{{button}}', userData['button']);
  htmlContent = htmlContent.replaceAll('{{link1}}', userData['link1']);
  htmlContent = htmlContent.replaceAll('{{link2}}', userData['link2']);
  htmlContent = htmlContent.replaceAll('{{footer}}', userData['footer_info']);
  htmlContent = htmlContent.replaceAll('{{css}}', '<style>$cssContent</style>');
  return htmlContent;
}
  Future<Map<String, dynamic>> _getUserDataFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Portfolio') 
          .doc('data')
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception("Aucune donnée trouvée pour cet utilisateur");
      }
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
      return await _getUserDataFromFirestore(userId); 
    }
  }


}



