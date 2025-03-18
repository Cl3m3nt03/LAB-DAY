import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:makeitcode/pages/community/private_message.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/system_getAvatar.dart';
import 'package:makeitcode/pages/profil/open_profil.dart';

/// A page that displays the list of contacts and their respective messages.
class ListFriend extends StatefulWidget {
  /// The unique identifier of the user.
  final String uid1;

  ListFriend({required this.uid1});

  @override
  _ListFriend createState() => _ListFriend();
}

/// The state for the [ContactPage] widget.
class _ListFriend extends State<ListFriend> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _avatarImage;

  Future<void> _loadAvatar() async {
    String? uid = Auth().currentUser?.uid;
    if (uid != null) {
      Uint8List? avatar = await AvatarService.getUserAvatar(uid);
      setState(() {
        _avatarImage = avatar;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 22, 44),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 11, 22, 44),
        child: Column(
          children: [
            Text(
              "AMIS",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 30,
                    color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: _firestore
                  .collection('Users')
                  .doc(widget.uid1)
                  .collection('Friends')
                  .doc('friends')
                  .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(
                      child: Text(
                        'Aucun ami trouvé',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  List<dynamic> friendIds = snapshot.data!.data()?['friends'] ?? [];
                  if (friendIds.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun ami trouvé',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return FutureBuilder<List<Map<String, dynamic>?>>(
                    future: Future.wait(friendIds.map((friendId) async {
                      DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
                          await _firestore.collection('Users').doc(friendId).get();
                      return friendSnapshot.data();
                    })),
                    builder: (context, friendSnapshot) {
                      if (friendSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!friendSnapshot.hasData) {
                        return Center(
                          child: Text(
                            'Erreur lors de la récupération des amis',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                      List<Map<String, dynamic>?> friendsData = friendSnapshot.data!;
                      return ListView.builder(
                        itemCount: friendsData.length,
                        itemBuilder: (context, index) {
                          var friendData = friendsData[index];
                          if (friendData == null) return SizedBox.shrink();

                          return Slidable(
                            key: ValueKey(friendData['uid']),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    _firestore
                                        .collection('Users')
                                        .doc(widget.uid1)
                                        .collection('Friends')
                                        .doc('friends')
                                        .update({
                                      'friends': FieldValue.arrayRemove(
                                          [friendData['uid']])
                                    }).then((_) {
                                      setState(() {});
                                    }).catchError((error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Erreur lors de la suppression: $error'),
                                        ),
                                      );
                                    });
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Supprimer',
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: InkWell(

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FutureBuilder<Uint8List?>(
                                          future: AvatarService.getUserAvatar(
                                              friendData['uid']),
                                          builder: (context, avatarSnapshot) {
                                            if (avatarSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircleAvatar(
                                                backgroundColor: Colors.grey[800],
                                                radius: 35,
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            if (avatarSnapshot.hasError ||
                                                avatarSnapshot.data == null) {
                                              return CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/icons/logo.png'),
                                                radius: 35,
                                              );
                                            }
                                            return CircleAvatar(
                                              backgroundImage: MemoryImage(
                                                  avatarSnapshot.data!),
                                              radius: 35,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friendData['pseudo'] ?? 'Inconnu',
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                             'Niveau : '+friendData['currentLvl'].toString() ,
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                      IconButton(
                                        onPressed: (){
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OpenProfilePage(
                                              uid: friendData['uid'] as String,
                                            ),
                                          ),
                                        );
                                          },
                                          icon: Icon(Icons.person, color: Colors.white, size: 30,
                                          )
                                        ),
                                        IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PrivateChatPage(
                                                recipiaentuid: friendData['uid'],
                                              ),
                                            ),
                                          );
                                       },
                                          icon: Icon(Icons.message, color: Colors.white, size: 30,
                                          )
                                        )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}