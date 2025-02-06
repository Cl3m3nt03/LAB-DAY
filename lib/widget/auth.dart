import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth {
  final ToastMessage toast = ToastMessage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  String? get uid => _auth.currentUser!.uid;
  String? get email => _auth.currentUser!.email;
  String? get username => _auth.currentUser!.displayName;
  String? pseudo;



  Stream<User?> get authStateChanges => _auth.authStateChanges();




  Future<void> signInWhithEmailAndPassword({
    required String email,
    required String password,

  }) async{
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void>createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }


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
      'totalpoints': 0,
      'objectiveXp':100,
    });
  }

  Future<void> sendPasswordResetEmail(String email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      toast.showToast(context,'Un email de réinitialisation de mot de passe a été envoyé à $email', isError: false);
    } on FirebaseAuthException {
      toast.showToast(context,'Email incorrect. Veuillez réessayer !', isError: true);

    }
  }

Future<void> signInWithGoogle( context) async {
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
    await _auth.signInWithCredential(credential);
    toast.showToast(context, 'Connexion réussie', isError: false);
    initializeUser(email:  Auth().email ?? '', username: Auth().username ?? '');
  } on FirebaseAuthException catch (e) {

    toast.showToast(context, 'Erreur de connexion : ${e.message}', isError: true);
  } catch (e) {
    toast.showToast(context, 'Une erreur inattendue est survenue.', isError: true);
  }
}

  Future<void> signOut() async{
    await _auth.signOut();
  }
  
}