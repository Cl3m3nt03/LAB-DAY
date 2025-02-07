import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  Future<String?> saveHTMLFile(String fileName, String htmlContent) async {
    try {
      // Obtention du répertoire de stockage de l'application
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory?.path}/$fileName.html';
      print("Fichier sauvegardé à : $filePath"); // Affiche le chemin dans la console

      // Création du fichier et écriture du contenu HTML
      final file = File(filePath);
      await file.writeAsString(htmlContent);

      return filePath; // Retourne le chemin du fichier
    } catch (e) {
      print('Erreur lors de la sauvegarde du fichier: $e');
      return null;
    }
  }
}

