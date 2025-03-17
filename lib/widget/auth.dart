import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Handles user authentication operations using Firebase Authentication.
class Auth {
  // Displays toast messages.
  final ToastMessage toast = ToastMessage();
  // Firebase Authentication instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firebase Firestore instance.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gets the current authenticated user.
  User? get currentUser => _auth.currentUser;
  // Gets the unique user ID.
  String? get uid => _auth.currentUser!.uid;
  // Gets the current user's email.
  String? get email => _auth.currentUser!.email;
  // Gets the current user's username.
  String? get username => _auth.currentUser!.displayName;
  // Stores the pseudo of the user.
  String? pseudo;


  // Stream that listens for authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();



  // Signs in with email and password.
  Future<void> signInWhithEmailAndPassword({
    required String email,
    required String password,

  }) async{
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Creates a new user with email and password.
  Future<void>createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

// Retrieves the pseudo from Firestore for the current user.
Future<String?> recoveryPseudo() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> doc = 
        await _firestore.collection('Users').doc(Auth().uid).get();

    if (doc.exists && doc.data() != null) {
      return doc.data()?['pseudo'] as String?;
    } else {
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération du pseudo : $e');
    return null;
  }
}
  // Initializes the user data in Firestore upon account creation.
  Future<void>initializeUser({
    required String email,
    required String username,
  }) async{
    await _firestore.collection('Users').doc( Auth().uid).set({
      'email': email,
      'uid': Auth().uid,
      'pseudo': username,
      'bio': 'L/Utilisateur n/a pas encore défini de bio',
      'currentLvl': 1,
      'currentXp': 0,
      'objectiveXp':100,
    });
  }
  // Sends a password reset email to the specified email address.
  Future<void> sendPasswordResetEmail(String email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      toast.showToast(context,'Un email de réinitialisation de mot de passe a été envoyé à $email', isError: false);
    } on FirebaseAuthException {
      toast.showToast(context,'Email incorrect. Veuillez réessayer !', isError: true);

    }
  }

// Signs in the user with Google authentication.
Future<void> signInWithGoogle(context) async {
  try {
    await GoogleSignIn().signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      toast.showToast(context, 'Connexion annulée', isError: true);
      return;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      // Appel de la fonction initializeUser pour initialiser l'utilisateur
       initializeUser(email: user.email!, username: user.displayName!);

      toast.showToast(context, 'Connexion réussie', isError: false);
    }
  } on FirebaseAuthException catch (e) {
    toast.showToast(context, 'Erreur de connexion : ${e.message}', isError: true);
  } catch (e) {
    toast.showToast(context, 'Une erreur inattendue est survenue.', isError: true);
  }
}
  // Signs the current user out.
  Future<void> signOut() async{
    await _auth.signOut();
  }
  
}