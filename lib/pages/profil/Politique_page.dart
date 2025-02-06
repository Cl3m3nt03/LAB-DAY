import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique de Confidentialité'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Politique de Confidentialité de l\'Application Make It Code',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text('Dernière mise à jour : [15/01/25]',
                style: TextStyle(fontStyle: FontStyle.italic)),
            SizedBox(height: 20.0),
            Text(
              'Introduction',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
                'Bienvenue sur Make It Code, une application d\'entraînement au code conçue pour aider les utilisateurs à améliorer leurs compétences en programmation. La confidentialité de vos informations est une priorité pour nous. Cette politique de confidentialité explique quelles données nous collectons, comment nous les utilisons, et vos droits concernant vos informations personnelles.'),
            SizedBox(height: 20.0),
            _buildSectionTitle('1. Données collectées'),
            _buildParagraph('Nous collectons deux types de données :'),
            _buildSubSection('1.1 Données personnelles fournies par l’utilisateur'),
            _buildBulletPoints([
              'Nom et prénom (si fournis lors de l’inscription).',
              'Adresse e-mail (nécessaire pour la création d\'un compte et la récupération de mot de passe).',
              'Photo de profil (si ajoutée via un service tiers comme Google ou GitHub).',
            ]),
            _buildSubSection('1.2 Données générées automatiquement'),
            _buildBulletPoints([
              'Statistiques d\'utilisation (temps passé, exercices complétés, scores, etc.).',
              'Informations sur l’appareil (modèle, système d’exploitation, version de l\'application).',
              'Adresse IP et données d’emplacement approximatif.',
            ]),
            SizedBox(height: 20.0),
            _buildSectionTitle('2. Utilisation des données'),
            _buildBulletPoints([
              'Fournir et personnaliser nos services.',
              'Analyser les performances et améliorer l’application.',
              'Communiquer avec vous, notamment pour des notifications ou des mises à jour importantes.',
              'Résoudre les problèmes techniques.',
            ]),
            SizedBox(height: 20.0),
            _buildSectionTitle('3. Partage des données'),
            _buildParagraph(
                'Nous ne vendons ni ne louons vos données personnelles. Toutefois, nous pouvons partager certaines informations dans les cas suivants :'),
            _buildBulletPoints([
              'Avec des prestataires tiers qui nous aident à fournir nos services (hébergement, analyse, gestion des notifications).',
              'Si requis par la loi ou pour protéger nos droits légaux.',
              'En cas de fusion, acquisition ou vente de l’application (vos données seraient transférées au nouvel opérateur).',
            ]),
            SizedBox(height: 20.0),
            _buildSectionTitle('4. Sécurité des données'),
            _buildParagraph(
                'Nous mettons en œuvre des mesures techniques et organisationnelles pour protéger vos données contre l\'accès non autorisé, la perte ou la destruction. Cependant, aucun système n\'est totalement sécurisé et nous ne pouvons garantir une sécurité absolue.'),
            SizedBox(height: 20.0),
            _buildSectionTitle('5. Conservation des données'),
            _buildParagraph(
                'Vos données personnelles seront conservées aussi longtemps que votre compte est actif ou que nécessaire pour fournir nos services. Vous pouvez demander la suppression de vos données à tout moment.'),
            SizedBox(height: 20.0),
            _buildSectionTitle('6. Vos droits'),
            _buildParagraph('Conformément à la législation en vigueur, vous disposez des droits suivants :'),
            _buildBulletPoints([
              'Accéder à vos données personnelles.',
              'Rectifier vos informations si elles sont incorrectes ou incomplètes.',
              'Supprimer vos données personnelles.',
              'Limiter ou vous opposer au traitement de vos données.',
              'Retirer votre consentement (par exemple, pour les notifications).',
              'Transférer vos données à un autre fournisseur (portabilité des données).',
            ]),
            _buildParagraph('Pour exercer ces droits, contactez-nous à [makeitcode@gmail.com].'),
            SizedBox(height: 20.0),
            _buildSectionTitle('7. Services tiers'),
            _buildParagraph(
                'Make It Code peut intégrer des services tiers, tels que :'),
            _buildBulletPoints([
              'Google (authentification).',
              'GitHub (authentification).',
              'Services d’analyse (par exemple, Google Analytics).',
            ]),
            _buildParagraph(
                'Ces services tiers collectent et utilisent vos données conformément à leurs propres politiques de confidentialité. Nous vous encourageons à les consulter.'),
            SizedBox(height: 20.0),
            _buildSectionTitle('8. Mineurs'),
            _buildParagraph(
                'Make It Code n’est pas destinée aux personnes de moins de 13 ans. Si nous apprenons que nous avons collecté des données personnelles d\'un enfant sans consentement parental vérifié, nous les supprimerons immédiatement.'),
            SizedBox(height: 20.0),
            _buildSectionTitle('9. Modifications de cette politique'),
            _buildParagraph(
                'Nous pouvons mettre à jour cette politique de confidentialité de temps à autre. Les modifications seront publiées sur cette page avec une date de mise à jour. Nous vous encourageons à consulter régulièrement cette politique.'),
            SizedBox(height: 20.0),
            _buildSectionTitle('10. Contact'),
            _buildParagraph(
                'Pour toute question ou préoccupation concernant cette politique de confidentialité, veuillez nous contacter à :'),
            _buildBulletPoints([
              'Email : [makeitcode@gmail.com]',
              'Adresse : [Coding Factory (Matéis Bourlet, Clément Seurrin-le-Goffic, Mathys Sclafer & Inès Charfi), 95000 Cergy]',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(fontSize: 14.0)),
              Expanded(
                child: Text(
                  point,
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}