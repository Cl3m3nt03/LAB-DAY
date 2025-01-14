import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage2 extends StatefulWidget {
  final String title;

  const HomePage2({super.key, required this.title});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState2();
  }
}

class _HomePageState2 extends State<HomePage2> {
  void _onButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GlossaryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onButtonPressed,
        backgroundColor: Color.fromARGB(255, 209, 223, 255),
        foregroundColor: Color(0xFF5E4F73),
        elevation: 1,
        child: const Icon(Icons.menu_book, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}



class GlossaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B162C),
      appBar: AppBar(backgroundColor: Color.fromRGBO(0, 113, 152, 1), foregroundColor: Colors.white,),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(0, 113, 152, 1),Color.fromARGB(255, 11, 22, 44)],
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
                  // HTML - Les bases
                  titreGlossaire(texte: "HTML - Les bases"),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Balise <p>",
                        "La balise <p> permet de créer un paragraphe dans une page HTML.",
                      );
                    },
                    icon: Icons.code,
                    texte: "<p> Balises",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Balise <a>",
                        "La balise <a> permet de créer des liens hypertexte. Exemple : <a href='https://example.com'>Lien</a>.",
                      );
                    },
                    icon: Icons.link,
                    texte: "<a> Liens",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Balise <img>",
                        "La balise <img> permet d'inclure des images. Exemple : <img src='image.jpg' alt='Image' />.",
                      );
                    },
                    icon: Icons.image,
                    texte: "<img> Image",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Balise <div>",
                        "La balise <div> permet de structurer la page en sections. Exemple : <div>Content</div>.",
                      );
                    },
                    icon: Icons.layers,
                    texte: "<div> Divisions",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Balise <form>",
                        "La balise <form> permet de créer des formulaires HTML pour collecter des informations.",
                      );
                    },
                    icon: Icons.text_fields,
                    texte: "<form> Formulaire",
                  ),
                  const SizedBox(height: 16),

                  // CSS - Styles
                  titreGlossaire(texte: "CSS - Styles"),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Background color",
                        "La propriété CSS `background-color` permet de définir la couleur de fond d'un élément.",
                      );
                    },
                    icon: Icons.format_paint,
                    texte: "Background color",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Padding",
                        "La propriété CSS `padding` ajoute des espaces internes autour du contenu d'un élément.",
                      );
                    },
                    icon: Icons.padding,
                    texte: "Padding",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Margin",
                        "La propriété CSS `margin` définit l'espace autour d'un élément.",
                      );
                    },
                    icon: Icons.margin,
                    texte: "Margin",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Font-size",
                        "La propriété CSS `font-size` définit la taille de la police d'un texte.",
                      );
                    },
                    icon: Icons.text_fields,
                    texte: "Font-size",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Flexbox",
                        "Le système Flexbox permet de créer des mises en page flexibles. Exemple : display: flex;",
                      );
                    },
                    icon: Icons.dashboard,
                    texte: "Flexbox",
                  ),
                  const SizedBox(height: 16),

                  // JavaScript - Logique
                  titreGlossaire(texte: "JavaScript - Logique"),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Incrémentation",
                        "L'incrémentation (`x++` ou `x += 1`) permet d'ajouter 1 à une variable.",
                      );
                    },
                    icon: Icons.add,
                    texte: "Incrémentation",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Décrémentation",
                        "La décrémentation (`x--` ou `x -= 1`) permet de soustraire 1 à une variable.",
                      );
                    },
                    icon: Icons.remove,
                    texte: "Décrémentation",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Boucles",
                        "Les boucles (for, while) permettent de répéter une série d'instructions plusieurs fois.",
                      );
                    },
                    icon: Icons.loop,
                    texte: "Boucles",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Conditions",
                        "Les conditions (`if`, `else`) permettent d'exécuter du code uniquement si une condition est remplie.",
                      );
                    },
                    icon: Icons.question_mark,
                    texte: "Conditions",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Fonctions",
                        "Les fonctions en JavaScript permettent de regrouper un ensemble d'instructions sous un même nom.",
                      );
                    },
                    icon: Icons.functions,
                    texte: "Fonctions",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Array",
                        "Un tableau (`Array`) est une structure qui permet de stocker plusieurs valeurs dans une seule variable.",
                      );
                    },
                    icon: Icons.view_array,
                    texte: "Array",
                  ),
                  const SizedBox(height: 16),

                  // Programmation générale
                  titreGlossaire(texte: "Programmation générale"),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Variables",
                        "Les variables stockent des valeurs. Exemple en JavaScript : let x = 10;",
                      );
                    },
                    icon: Icons.abc,
                    texte: "Variables",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Constantes",
                        "Les constantes sont des variables dont la valeur ne peut pas être modifiée. Exemple : const x = 10;",
                      );
                    },
                    icon: Icons.lock,
                    texte: "Constantes",
                  ),
                  const SizedBox(height: 8),
                  buttonGlossaire(
                    onPressed: () {
                      showDescription(
                        context,
                        "Opérateurs arithmétiques",
                        "Les opérateurs arithmétiques permettent de faire des calculs sur des nombres. Exemple : +, -, *, /",
                      );
                    },
                    icon: Icons.calculate,
                    texte: "Opérateurs",
                  ),
                ],
              ),
            ),
          )

      ),
    );
  }

  // Fonction pour afficher un dialogue avec la description
  void showDescription(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
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
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 44, 3, 65)),
              ),
            ],
          ),
        );
      },
    );
  }

}

Text titreGlossaire({required String texte}){
  return  Text(
      texte,
      style: GoogleFonts.aBeeZee(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),)
  );
}

// Fonction pour créer un bouton stylisé pour le glossaire
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
