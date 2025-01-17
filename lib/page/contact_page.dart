import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/page/private_message.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:makeitcode/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatelessWidget {
  final String uid1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;


  ContactPage({required this.uid1});

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchMessagesWithUid() {
    return FirebaseFirestore.instance
        .collection('Private_Chat')
        .where('participants', arrayContains: uid1)
        .snapshots();
  }
  Future<void> _getcontact() async {
    try {
      await _firestore.collection('Users').doc(uid1).get();
    } catch (e) {
      print('Erreur lors de la récupération des pseudos : $e');
    }
  }

  Future<void> viewed(){
    return _firestore.collection('Private_Chat').doc(uid1).update({
      'viewed': false,
    });
  }

Future<String> countViewed() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('Private_Chat')
        .where('participants', arrayContains: uid1) 
        .get();

    int totalUnread = 0;


    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();

    
      if (data.containsKey('unreadCount') && data['unreadCount'] is Map) {
        totalUnread += (data['unreadCount'][uid1] ?? 0) as int; 
      }
    }
    return totalUnread.toString();
  } catch (e) {
    print('Erreur lors de la récupération des messages non lus : $e');
    return 'Erreur';
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Messages privés', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body:Container(
        color:Color.fromARGB(255, 11, 22, 44) ,
        child : Padding(
          padding: EdgeInsets.all(10),
          child:
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( 
        stream: _fetchMessagesWithUid(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur lors de la récupération des contacts'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Map<String, dynamic>> document =
                  documents[index];
              List<dynamic> participants = document['participants'];
              String test = 'Je suis le dernier message pas encore developpé'; 
              String uid2 = participants.firstWhere(
                (element) => element != uid1, 
                orElse: () => uid1, 
              );
               return Container(
                child:
               InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivateChatPage(
                        recipiaentuid: uid2,
                      ),
                    ),
                  );
                },
                child:
               Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/avatar.jpg',
                            width: 50,
                            height: 50,
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
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text(
                                    'Erreur lors de la récupération des pseudos',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                                if (!snapshot.hasData || !snapshot.data!.exists) {
                                  return Text(
                                    'Utilisateur non trouvé',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                                var userData = snapshot.data!.data() as Map<String, dynamic>;
                                return Text(
                                  userData['pseudo'] ?? 'Pseudo non disponible',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 5), 
                            Text(
                              test,
                              style: TextStyle(
                                color: Color.fromARGB(162, 255, 255, 255),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.visible, 
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10, top: 10),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: 
                                FutureBuilder<String>(
                                  future: countViewed(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text(
                                        'Erreur',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return Text(
                                      snapshot.data ?? '0',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              
                            ),
                        ),
                    ],
                  ),
                  Divider(),
                ],
              ),
               ),
              );
            },
          );
        },
      ),
      ),
      ),
    );
  }
}