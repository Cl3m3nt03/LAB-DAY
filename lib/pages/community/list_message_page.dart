import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:makeitcode/pages/community/private_message.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatefulWidget {
  final String uid1;

  ContactPage({required this.uid1});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchMessagesWithUid() {
    return _firestore
        .collection('Private_Chat')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.where((doc) {
            var data = doc.data();
            List<dynamic> visibility = data['visibility'] ?? [];
            return !visibility.contains(uid);
          }).toList();
        });
  }

  Future<void> setMessageAsViewed(String chatId) async {
    try {
      DocumentReference docRef = _firestore.collection('Private_Chat').doc(chatId);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('unreadCount') && data['unreadCount'] is Map) {
          Map<String, dynamic> unreadCount = Map<String, dynamic>.from(data['unreadCount']);
          unreadCount[uid] = 0;
          await docRef.update({'unreadCount': unreadCount});
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du message en vu : $e');
    }
  }

  Future<int> unreadCount(String chatId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('Private_Chat').doc(chatId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('unreadCount') && data['unreadCount'] is Map) {
          int count = data['unreadCount'][uid] ?? 0;
          return count;
        }
      }
      return 0;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de messages non lus : $e');
      return 0;
    }
  }

  Future<String> lastMessage(String chatId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('Private_Chat')
          .doc(chatId)
          .collection('messages')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = querySnapshot.docs.first.data();
        return data['message'] ?? 'Aucun contenu';
      }
      return 'Aucun message';
    } catch (e) {
      print('Erreur lors de la récupération du dernier message : $e');
      return 'Erreur';
    }
  }

  Future<String> lastMessageDate(String chatId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('Private_Chat')
          .doc(chatId)
          .collection('messages')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = querySnapshot.docs.first.data();
        Timestamp timestamp = data['date'];
        DateTime dateTime = timestamp.toDate();
        DateTime now = DateTime.now();
        String formattedTime;
        if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
          formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
        } else {
          formattedTime = DateFormat('dd/MM/yyyy').format(dateTime);
        }
        return formattedTime;
      }
      return '00:00';
    } catch (e) {
      print('Erreur lors de la récupération de la date : $e');
      return 'Erreur';
    }
  }

  void noShowMessage(String chatId) async {
    try {
      await _firestore.collection('Private_Chat').doc(chatId).update({
        'visibility': FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      print('Erreur lors de la mise à jour de la visibilité : $e');
    }
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
              "MESSAGES",
              style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 30,color: Colors.white),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text("Future barre de recherche"),
                ),
              ),
            ),
            StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              stream: _fetchMessagesWithUid(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur lors de la récupération des contacts'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Map<String, dynamic>> document = documents[index];
                      List<dynamic> participants = document['participants'];
                      String uid2 = participants.firstWhere(
                        (element) => element != widget.uid1,
                        orElse: () => widget.uid1,
                      );
                      String chatId = document.id;

                      return Slidable(
                        key: ValueKey(chatId),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                noShowMessage(chatId);
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
                            onTap: () {
                              setMessageAsViewed(chatId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrivateChatPage(
                                    recipiaentuid: uid2,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(
                                          'assets/images/avatar.jpg',
                                          width: 65,
                                          height: 65,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<DocumentSnapshot>(
                                            future: _firestore.collection('Users').doc(uid2).get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Text(
                                                  'Chargement...',
                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'Erreur',
                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                );
                                              }
                                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                                return Text(
                                                  'Utilisateur inconnu',
                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                );
                                              }
                                              var userData = snapshot.data!.data() as Map<String, dynamic>;
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    userData['pseudo'] ?? 'Pseudo inconnu',
                                                    style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 17,color: Colors.white),),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(height: 7),
                                          FutureBuilder<String>(
                                            future: lastMessage(chatId),
                                            builder: (context, snapshot) {
                                              return FutureBuilder<int>(
                                                future: unreadCount(chatId),
                                                builder: (context, unreadSnapshot) {
                                                  return Text(
                                                    snapshot.data ?? 'Aucun message',
                                                    style: GoogleFonts.montserrat(textStyle: TextStyle( color: (unreadSnapshot.data ?? 0) > 0 ? Colors.white : Colors.white70,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,fontSize: 14),),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  );
                                                }
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10, top: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          FutureBuilder<String>(
                                            future: lastMessageDate(chatId),
                                            builder: (context, snapshot) {
                                              return Text(
                                                snapshot.data ?? '00:00',
                                                    style: GoogleFonts.montserrat(textStyle: TextStyle( color:Colors.white70,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,fontSize: 13),),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 10),

                                          Center(
                                            child: FutureBuilder<int>(
                                              future: unreadCount(chatId),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return Text(
                                                    '!',
                                                    style: TextStyle(color: Colors.white),
                                                  );
                                                }
                                                int unreadCount = snapshot.data ?? 0;
                                                return unreadCount > 0
                                                    ? Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            unreadCount.toString(),
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                      height: 20,
                                                      width: 20,
                                                    );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}