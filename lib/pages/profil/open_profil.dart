import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:makeitcode/theme/custom_colors.dart';


// Widget representing the user's profile page.
class OpenProfilePage extends StatefulWidget {
  final String uid; // User ID for fetching profile data.

  OpenProfilePage({required this.uid});

  @override
  _OpenProfilePageState createState() => _OpenProfilePageState();
}

class _OpenProfilePageState extends State<OpenProfilePage> {
  CustomColors? customColor;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ToastMessage toast = ToastMessage();
  String bio = '';
  String name = '';
  int level = 0;
  String pseudo = '';
  int lvl = 0;
  int xp = 0;
  Uint8List? avatar1;
  int objXp = 100;
  Uint8List? _avatarImage;

  /// Initializes the profile page and fetches the profile data and avatar.
  @override
  void initState() {
    super.initState();
    getProfile();
    _loadAvatar();
  }
  

  @override
  void didUpdateWidget(covariant OpenProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
     /// Updates the profile data if the UID changes.
      getProfile();
    }
  }

  /// Loads the avatar image for the user.
    Future<void> _loadAvatar() async {
    String? uid = Auth().currentUser?.uid;
    if (uid != null) {
      await getProfile();
      setState(() {
        _avatarImage = avatar1 as Uint8List?;
      });
    }
  }
  


    /// Fetches the profile data from Firestore for the given UID.
  Future<void> getProfile() async {
    setState(() {
    //Reset to avoid showing old data      
      bio = '';
      name = '';
      level = 0;
      Uint8List? avatar1 = null;
    });

    try {
      final doc = await _firestore.collection('Users').doc(widget.uid).get();
      if (doc.exists) {
        setState(() {
          name = doc.data()?['pseudo'] ?? '';
          bio = doc.data()?['bio'] ?? '';
          level = doc.data()?['currentLvl'] ?? 0;
          avatar1 = doc.data()?['avatar'] != null ? base64Decode(doc.data()?['avatar']) : null;
          xp = doc.data()?['currentXp'] ?? 0; 
          objXp = doc.data()?['objectiveXp'] ?? 100;
        });
      }
    } catch (e) {
      print('Error fetching profil: $e');
    }
  }

  /// Returns the title section with name and bio.
  Widget _title(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*0.6,
          child:
        Text(
          bio.isNotEmpty ? bio : 'No bio',
          style: GoogleFonts.nokora(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
        ),
      ],
  );
}
  /// Determines the rank based on the player's level.
  getlvlRank(int lvl){
    if(level >= 0 || level <= 5){
      return 'Débutant';
    }
    return 'Novice';
  }
  /// Returns the badge icon path based on the player's level.
  getlvlBadge(int level){
    String path = 'assets/icons/';
    if(level >= 0 || level <= 5){
      return '${path}BronzeIcon.png';
    }
    return '${path}BronzeIcon.png';
  }

/// Returns the profile picture widget with the user's avatar.
Widget _profilePicture(){
  return CircleAvatar(
    backgroundImage: _avatarImage != null
    ? MemoryImage(_avatarImage!)
    : AssetImage('assets/icons/logo.png')
        as ImageProvider,
    radius: 50,
  );
}
  /// Displays the player's level with experience progress.
  Widget _playerLevel(){
  return Container(
    width: MediaQuery.of(context).size.width - 25,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff0692C2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff0692C2).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
                  Text(
                    getlvlRank(lvl),
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      )
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Color(0xffE6E6E6).withOpacity(0.64),
                        borderRadius:  BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), 
                          ),
                        ],
                    ),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Niv. ',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5), 
                                  fontWeight: FontWeight.normal, 
                                  fontSize: 16, 
                                ),
                              ),
                              TextSpan(
                                text: '$level', 
                                style: TextStyle(
                                  color: Colors.black, 
                                  fontWeight: FontWeight.w800, 
                                  fontSize: 17, 
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5,),
                        Image(
                          image: AssetImage(getlvlBadge(lvl)),
                          height: 25,
                        )
                      ],
                    )
                  )
            ],
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 25,
            child: Progressbar(percentageCompletion: (xp/objXp)*100, showPercentage:  false),
          ),
          Row(
            children: [
              Text(
                "$xp xp",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              Spacer(),
              Text(
                "$objXp xp",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ],
          ),
        ],
      ),
  );
}
/// Displays the user's badges.
Widget _badges(){
  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Badges : ',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            )
          ),
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Image(
              image: AssetImage('assets/icons/BronzeIcon.png'),
              height: 50,
            ),
            SizedBox(width: 30,),
            Image(
              image: AssetImage('assets/icons/BronzeIcon.png'),
              height: 50,
            ),
            SizedBox(width: 30,),
            Image(
              image: AssetImage('assets/icons/BronzeIcon.png'),
              height: 50,
            ),
          ],
        )
      ],
    ),
  );
}

/// Displays the museum section with the player's achievements.
Widget _Museum(){
  return Container(
    width: MediaQuery.of(context).size.width - 10,
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Museum : ',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            )
          ),
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 30,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(10), 
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/icons/BronzeIcon.png'),
                    height: 50,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Bronze',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Image(
                    image: AssetImage('assets/icons/BronzeIcon.png'),
                    height: 50,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Bronze',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      )
                    ),
                  ),
                ],
              ),
            ),
            ),
          ],
        )
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title:Text(
          'Profil de $name',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 22,
                color: Colors.white),
          ),
        ),
        backgroundColor: customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
                await _firestore.collection('Users').doc(Auth().uid).collection('Friends').doc('friends').set(
                            {
                              'friends': FieldValue.arrayUnion([widget.uid]),
                            },
                            SetOptions(merge: true),
                        );
                await _firestore.collection('Users').doc(widget.uid).collection('Friends').doc('friends').set(
                            {
                              'friends': FieldValue.arrayUnion([Auth().uid]),
                            },
                            SetOptions(merge: true),
                        );
                toast.showToast( context,  "Vous avez ajoutez "+ name+"!");
            },
          ),
        ],
      ),
      body: Stack(
         children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(0, 113, 152, 1),
                  customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
                ],
                stops: [0.1, 0.9],
                center: Alignment(-0.7, 0.7),
                radius: 0.8,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        _title(),
                        _profilePicture()
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  _playerLevel(),
                  SizedBox(height: 25),
                  _badges(),
                  SizedBox(height: 25),
                  _Museum(),            
                ],
              ),
            ),
          ),
         ],
      ),
    ); 
  }
}