// Comment utiliser les messages toast signé Mateis le bg :
  /// Importez le fichier toastMessage.dart dans votre fichier.
  
  /// import 'package:makeitcode/widget/toastMessage.dart';

  /// Créez une instance de la classe ToastMessage.
  
  /// final ToastMessage toast = ToastMessage();

  /// Utilisez la méthode showToast pour afficher un message toast.
  
  /// Exemple : Affichage d'un message de succès.
  /// toast.showToast(context, "Action réussie !");

  /// Exemple : Affichage d'un message d'erreur.
  /// toast.showToast(context, "Une erreur est survenue", isError: true);


import 'package:flutter/material.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class ToastMessage {
  void showToast(BuildContext context, String message, {bool isError = false}) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(seconds: 2),
      builder: (context) => ToastCard(
        color: isError ? Colors.red : Colors.green,
        leading: Icon(
          isError ? Icons.error : Icons.check_circle,
          color: Colors.white,
          size: 28,
        ),
        title: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }
}
