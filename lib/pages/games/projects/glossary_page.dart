import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:makeitcode/widget/style_editor.dart';
import 'package:makeitcode/theme/custom_colors.dart';

/// Glossary page widget, used to display the glossary interface.
class GlossaryPage extends StatefulWidget {
  /// Creates the state for the GlossaryPage widget.
  @override
  State<StatefulWidget> createState() {
    return _GlossaryPage();
  }
}

/// Glossary content page displaying glossary items and descriptions.
class _GlossaryPage extends State<GlossaryPage> {
  CustomColors? customColor;
  /// Builds the GlossaryContentPage layout with a gradient background and glossary items.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B162C),
      appBar: AppBar(backgroundColor: Color.fromRGBO(0, 113, 152, 1), foregroundColor: Colors.white,),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(0, 113, 152, 1),customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44)],
              stops: [0.2, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Glossary item buttons for HTML elements and descriptions

                // HTML - Les bases
                titreGlossaire(texte: "HTML - Les bases"),
                const SizedBox(height: 8),
                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Structure de base",
                    "HTML", // Langage ajouté ici
                    "HTML est un langage de balisage utilisé pour structurer le contenu des pages web.",
                    "<!DOCTYPE html>\n<html>\n  <head>\n    <title>Page Web</title>\n  </head>\n  <body>\n    <h1>Bonjour le monde</h1>\n  </body>\n</html>",
                  ),
                  icon: Icons.code,
                  texte: "Structure de base",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Balises de structure",
                    "HTML",
                    "Les balises comme <html>, <head>, <body> et <title> sont essentielles pour la structure d'une page web.",
                    "<html>\n  <head>\n    <title>Ma page web</title>\n  </head>\n  <body>\n    <h1>Bienvenue</h1>\n  </body>\n</html>",
                  ),
                  icon: Icons.code,
                  texte: "Balises de structure",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Titres",
                    "HTML",
                    "Les balises de titres (<h1> à <h6>) servent à structurer le contenu et à hiérarchiser l'information.",
                    "<h1>C'est un titre principal</h1>\n<h2>C'est un sous-titre</h2>\n<h3>Un titre secondaire</h3>",
                  ),
                  icon: Icons.title,
                  texte: "Titres",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Paragraphes",
                    "HTML",
                    "La balise <p> est utilisée pour structurer les paragraphes dans un document HTML.",
                    "<p>Ceci est un paragraphe de texte dans un document HTML.</p>",
                  ),
                  icon: Icons.text_fields,
                  texte: "Paragraphes",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Liens",
                    "HTML",
                    "Les balises <a> sont utilisées pour créer des liens hypertextes.",
                    "<a href='https://www.example.com'>Cliquez ici pour visiter notre site</a>",
                  ),
                  icon: Icons.link,
                  texte: "Liens",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Listes",
                    "HTML",
                    "Les balises <ul> et <ol> sont utilisées pour créer des listes non ordonnées et ordonnées, respectivement.",
                    "<ul>\n  <li>Item 1</li>\n  <li>Item 2</li>\n</ul>",
                  ),
                  icon: Icons.list,
                  texte: "Listes",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Images",
                    "HTML",
                    "La balise <img> permet d'intégrer des images dans une page web.",
                    "<img src='image.jpg' alt='Une image' />",
                  ),
                  icon: Icons.image,
                  texte: "Images",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Tableaux",
                    "HTML",
                    "Les tableaux sont créés avec les balises <table>, <tr>, <td> et <th>.",
                    "<table>\n  <tr>\n    <th>Titre 1</th>\n    <th>Titre 2</th>\n  </tr>\n  <tr>\n    <td>Valeur 1</td>\n    <td>Valeur 2</td>\n  </tr>\n</table>",
                  ),
                  icon: Icons.table_chart,
                  texte: "Tableaux",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "HTML - Formulaires",
                    "HTML",
                    "Les balises <form>, <input> et <button> sont utilisées pour créer des formulaires interactifs.",
                    "<form action='/submit' method='post'>\n  <input type='text' name='name' />\n  <button type='submit'>Envoyer</button>\n</form>",
                  ),
                  icon: Icons.input,
                  texte: "Formulaires",
                ),
                const SizedBox(height: 8),


                // CSS - Styles
                                
                titreGlossaire(texte: "CSS - Styles"),
                const SizedBox(height: 8),
                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Couleurs",
                    "CSS", // Langage ajouté ici
                    "CSS est utilisé pour appliquer des styles visuels aux éléments HTML.",
                    "body {\n  background-color: #f0f0f0;\n  color: #333333;\n}",
                  ),
                  icon: Icons.color_lens,
                  texte: "Couleurs",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Police de caractères",
                    "CSS",
                    "La propriété font-family définit la police de caractères utilisée dans le texte.",
                    "h1 {\n  font-family: Arial, sans-serif;\n}",
                  ),
                  icon: Icons.text_fields,
                  texte: "Police de caractères",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Taille de police",
                    "CSS",
                    "La propriété font-size permet de définir la taille du texte.",
                    "p {\n  font-size: 16px;\n}",
                  ),
                  icon: Icons.format_size,
                  texte: "Taille de police",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Espacement",
                    "CSS",
                    "Les propriétés margin et padding contrôlent l'espacement autour des éléments.",
                    "div {\n  margin: 20px;\n  padding: 10px;\n}",
                  ),
                  icon: Icons.space_bar,
                  texte: "Espacement",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Bordures",
                    "CSS",
                    "La propriété border permet de définir une bordure autour des éléments.",
                    "div {\n  border: 2px solid #000000;\n}",
                  ),
                  icon: Icons.border_all,
                  texte: "Bordures",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Alignement",
                    "CSS",
                    "La propriété text-align permet d'aligner le texte à gauche, à droite ou au centre.",
                    "p {\n  text-align: center;\n}",
                  ),
                  icon: Icons.align_horizontal_center,
                  texte: "Alignement",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Positionnement",
                    "CSS",
                    "La propriété position permet de définir la méthode de positionnement des éléments sur la page.",
                    "div {\n  position: absolute;\n  top: 50px;\n  left: 100px;\n}",
                  ),
                  icon: Icons.pin_drop,
                  texte: "Positionnement",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Flexbox",
                    "CSS",
                    "Flexbox est une méthode de mise en page qui permet d'aligner et de distribuer l'espace entre les éléments.",
                    "div {\n  display: flex;\n  justify-content: space-between;\n}",
                  ),
                  icon: Icons.view_quilt,
                  texte: "Flexbox",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Grille",
                    "CSS",
                    "CSS Grid Layout permet de créer des mises en page complexes avec une grille de colonnes et de lignes.",
                    "div {\n  display: grid;\n  grid-template-columns: 1fr 1fr;\n}",
                  ),
                  icon: Icons.grid_on,
                  texte: "Grille",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "CSS - Ombres",
                    "CSS",
                    "Les propriétés box-shadow et text-shadow permettent d'ajouter des ombres aux éléments et au texte.",
                    "div {\n  box-shadow: 5px 5px 10px rgba(0, 0, 0, 0.3);\n}",
                  ),
                  icon: Icons.blur_on,
                  texte: "Ombres",
                ),
                const SizedBox(height: 8),

                // JavaScript - Logique
                titreGlossaire(texte: "JavaScript - Logique"),
                const SizedBox(height: 8),
                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Fonction",
                    "JavaScript", // Langage ajouté ici
                    "Les fonctions permettent de structurer et de réutiliser le code.",
                    "function saluer() {\n  alert('Bonjour tout le monde!'); // Affiche une alerte avec le message 'Bonjour tout le monde!'.\n}",
                  ),
                  icon: Icons.code,
                  texte: "Fonction",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Variables",
                    "JavaScript",
                    "Les variables servent à stocker des données que l'on peut réutiliser dans le code.",
                    "let message = 'Bonjour';\nconsole.log(message); // Affiche la valeur de la variable 'message' dans la console. Ici, 'Bonjour'.",
                  ),
                  icon: Icons.storage,
                  texte: "Variables",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Conditions",
                    "JavaScript",
                    "Les conditions permettent d'exécuter du code en fonction de certaines valeurs.",
                    "if (age >= 18) {\n  alert('Vous êtes majeur.'); // Si 'age' est supérieur ou égal à 18, affiche 'Vous êtes majeur'.\n} else {\n  alert('Vous êtes mineur.'); // Sinon, affiche 'Vous êtes mineur'.\n}",
                  ),
                  icon: Icons.equalizer,
                  texte: "Conditions",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Boucles",
                    "JavaScript",
                    "Les boucles permettent de répéter des actions plusieurs fois.",
                    "for (let i = 0; i < 5; i++) {\n  console.log(i); // Affiche les nombres de 0 à 4 dans la console.\n}",
                  ),
                  icon: Icons.loop,
                  texte: "Boucles",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Tableaux",
                    "JavaScript",
                    "Les tableaux sont utilisés pour stocker plusieurs valeurs dans une seule variable.",
                    "let fruits = ['Pomme', 'Banane', 'Cerise'];\nconsole.log(fruits[0]); // Affiche 'Pomme', l'élément à l'index 0 du tableau 'fruits'.",
                  ),
                  icon: Icons.list,
                  texte: "Tableaux",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Objets",
                    "JavaScript",
                    "Les objets permettent de regrouper des valeurs sous forme de paires clé-valeur.",
                    "let personne = { nom: 'John', age: 30 }; \nconsole.log(personne.nom); // Affiche 'John', la valeur associée à la clé 'nom' de l'objet 'personne'.",
                  ),
                  icon: Icons.account_box,
                  texte: "Objets",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Evénements",
                    "JavaScript",
                    "Les événements permettent de réagir à des actions de l'utilisateur, comme un clic ou une touche de clavier.",
                    "button.addEventListener('click', function() {\n  alert('Button clicked'); // Affiche une alerte lorsque le bouton est cliqué.\n});",
                  ),
                  icon: Icons.touch_app,
                  texte: "Evénements",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Promesses",
                    "JavaScript",
                    "Les promesses sont utilisées pour gérer des opérations asynchrones.",
                    "let promise = new Promise((resolve, reject) => {\n  resolve('Opération réussie'); // Si l'opération réussit, résout la promesse.\n});\npromise.then(result => {\n  console.log(result); // Affiche 'Opération réussie' dans la console.\n});",
                  ),
                  icon: Icons.pending,
                  texte: "Promesses",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Asynchrone",
                    "JavaScript",
                    "Les fonctions asynchrones permettent de gérer les tâches longues sans bloquer l'exécution.",
                    "async function fetchData() {\n  let response = await fetch('url');\n  let data = await response.json();\n  console.log(data); // Affiche les données récupérées de l'URL dans la console.\n}",
                  ),
                  icon: Icons.access_time,
                  texte: "Asynchrone",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "JavaScript - Modules",
                    "JavaScript",
                    "Les modules permettent d'organiser le code en fichiers séparés.",
                    "import { myFunction } from './myModule';\nmyFunction(); // Importe la fonction 'myFunction' du module 'myModule' et l'exécute.",
                  ),
                  icon: Icons.library_books,
                  texte: "Modules",
                ),
                const SizedBox(height: 8),


                // Programmation générale
                titreGlossaire(texte: "Programmation générale"),
                const SizedBox(height: 8),
                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Boucle",
                    "dart", // Langage ajouté ici
                    "Les boucles permettent de répéter un bloc de code plusieurs fois.",
                    "for (int i = 0; i < 10; i++) {\n  print(i); // Ce code affiche les nombres de 0 à 9 dans la console.\n}",
                  ),
                  icon: Icons.loop,
                  texte: "Boucle",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Condition",
                    "dart",
                    "Les conditions permettent d'exécuter un bloc de code si une certaine condition est vraie.",
                    "if (age >= 18) {\n  print('Vous êtes majeur');\n} else {\n  print('Vous êtes mineur');\n} // Ce code affiche \"Vous êtes majeur\" ou \"Vous êtes mineur\" selon la valeur de 'age'.",
                  ),
                  icon: Icons.equalizer,
                  texte: "Condition",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Liste",
                    "dart",
                    "Les listes permettent de stocker plusieurs éléments dans une seule variable.",
                    "List<int> nombres = [1, 2, 3, 4, 5];\nprint(nombres[0]); // Ce code affiche 1, car c'est l'élément à l'index 0 de la liste.",
                  ),
                  icon: Icons.list,
                  texte: "Liste",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Fonction",
                    "dart",
                    "Les fonctions permettent de structurer et de réutiliser du code.",
                    "void saluer() {\n  print('Bonjour');\n}\nsaluer(); // Ce code affiche 'Bonjour' dans la console.",
                  ),
                  icon: Icons.code,
                  texte: "Fonction",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Map",
                    "dart",
                    "Les maps permettent de stocker des paires clé-valeur.",
                    "Map<String, int> ages = {'Alice': 25, 'Bob': 30};\nprint(ages['Alice']); // Ce code affiche 25, la valeur associée à la clé 'Alice'.",
                  ),
                  icon: Icons.map,
                  texte: "Map",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Exception",
                    "dart",
                    "Les exceptions permettent de gérer les erreurs qui peuvent survenir pendant l'exécution du code.",
                    "try {\n  int result = 10 ~/ 0;\n} catch (e) {\n  print('Erreur: \$e'); // Ce code affiche 'Erreur: IntegerDivisionByZeroException' car la division par zéro est impossible.\n}",
                  ),
                  icon: Icons.error,
                  texte: "Exception",
                ),
                const SizedBox(height: 8),

                buttonGlossaire(
                  onPressed: () => showDescription(
                    context,
                    "Programmation - Classe",
                    "dart",
                    "Les classes sont des modèles pour créer des objets avec des propriétés et des méthodes.",
                    "class Personne {\n  String nom;\n  int age;\n\n  Personne(this.nom, this.age);\n\n  void saluer() {\n    print('Bonjour, je m'appelle \$nom');\n  }\n}\n\nvar p = Personne('Alice', 25);\np.saluer(); // Ce code crée un objet Personne et affiche 'Bonjour, je m'appelle Alice'.",
                  ),
                  icon: Icons.person,
                  texte: "Classe",
                ),
                const SizedBox(height: 8),

                ],

              ),
            ),
          )

      ),
    );
  }

  /// Displays a description dialog with a glossary item's details and code sample.
  void showDescription(BuildContext context, String title, String langage, String description, String code) {

    showModalBottomSheet(
      context: context,
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
        child :  Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 169, 186, 220), // Couleur de fond
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),

          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 47, 3, 69)
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 59, 49, 64)
                ),
              ),
              const SizedBox(height: 8),
              
              HighlightView(
              code ,
              language: langage, // Définir le bon langage ici
              theme: shadesOfPurpleTheme,  // Appliquer le thème personnalisé
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(
                fontFamily: 'Monospace',
                fontSize: 16,
              ),
            ),
            ],
          ),
        ),
        );
      },
    );
  }
}
/// Displays a glossary item title with specific text style.

Text titreGlossaire({required String texte}){
  return  Text(
      texte,
      style: GoogleFonts.aBeeZee(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),)
  );
}

/// Creates a stylized button for glossary items with an icon and text.
ElevatedButton buttonGlossaire({
  required VoidCallback onPressed,
  required IconData icon,
  required String texte,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(119, 146, 155, 0.7),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 79, 89, 115),
          width: 2,
        ),
      ),
      elevation: 2,
    ),
    child: Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color.fromARGB(255, 232, 228, 243),
        ),
        const SizedBox(width: 20),
        Text(
          texte,
          style: GoogleFonts.numans(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
