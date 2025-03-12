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
  htmlContent = htmlContent.replaceAll('{{name}}', userData['name'] ?? 'Nom par défaut');
  htmlContent = htmlContent.replaceAll('{{aboutMe}}', userData['aboutMe'] ?? 'À propos par défaut');
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
      await _initProject(userId);
      return await _getUserDataFromFirestore(userId); 
    }
  }

  Future _initProject(userId) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).collection('Portfolio').doc('data').set({
      'Structure de base': '',
      'Nom par défaut': 'Nom par défaut',
      'À propos par défaut': 'À propos par défaut',
      'Email par défaut': 'Email par défaut',
      'Téléphone par défaut': 'Téléphone par défaut',
      'Compétence 1': 'Compétence 1',
      'Compétence 2': 'Compétence 2',
      'Projet 1': 'Projet 1',
      'Projet 2': 'Projet 2',
      'Ajout d\'une image': 'Image par défaut',
      'Ajout de liens externes': 'Lien par défaut',
      "Ajout d'un lien vers GitHub": 'Lien par défaut',
      'Tableau des compétences':'Tableau par défaut',
      "Ajout d'une section 'Compétences techniques'": 'Section par défaut',
      'Ajout d\'une liste de projets': 'Liste par défaut',
      'Section de témoignages': 'Section par défaut',
      "Ajout d'un formulaire de contact": 'Formulaire par défaut',
      "Ajout d'un bouton 'Retour en haut'" : 'Bouton par défaut',
      'Footer': 'Footer par défaut',
      'Finalisation du portfolio': 'Finalisation par défaut',
      'css': 'dark'
    });

    return;
  }
}



