import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loadDataAndTemplate {

  // Récupère le chemin du fichier HTML généré
  Future<String> getHtmlFilePath(String templateName) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$templateName';
  }

Future<void> generateHTMLFromFirestore(String userId, String templateName) async {
  // Recup des données sur Firestore
  Map<String, dynamic> userData = await _getUserDataFromFirestore(userId);

  // Charge le template HTML depuis les assets
  String htmlContent = await _loadHtmlTemplate(templateName);

  // Charger le CSS depuis les assets
  String cssContent = await _loadCss("pink");

  // Remplacer les placeholders par les données utilisateur et appliquer le CSS
  htmlContent = _replaceData(htmlContent, userData, cssContent);

  // Enregistrer le fichier HTML dans le téléphone
  final filePath = await getHtmlFilePath(templateName);
  final file = File(filePath);
  await file.writeAsString(htmlContent);
}

  Future<String> _loadCss(themeCss) async {
  final String cssContent = await rootBundle.loadString('assets/project_template/portfolio/$themeCss.css');
  return cssContent;
}

  Future<String> _loadHtmlTemplate(templateName) async {
    // Charger le template HTML depuis les assets
    final String htmlTemplate = await rootBundle.loadString('assets/project_template/portfolio/$templateName');
    return htmlTemplate;
  }

String _replaceData(String htmlContent, Map<String, dynamic> userData, String cssContent) {
  // Remplacer les valeurs par défaut par les données utilisateur
  htmlContent = htmlContent.replaceAll('{{name}}', userData['name'] ?? 'Nom par défaut');
  htmlContent = htmlContent.replaceAll('{{aboutMe}}', userData['aboutMe'] ?? 'À propos par défaut');
  //Intégration direct de tous le css dans le fichier html
  htmlContent = htmlContent.replaceAll('{{css}}', '<style>$cssContent</style>');
  return htmlContent;
}
  // Récupère les données utilisateur depuis Firestore et les stock dans une map clé-valeur
  Future<Map<String, dynamic>> _getUserDataFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('test').doc(userId).get();
      
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception("Aucune donnée trouvée pour cet utilisateur");
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération des données : $e");
    }
  }
}
