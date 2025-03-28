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
import 'package:makeitcode/theme/custom_colors.dart';

/// A page that displays the list of contacts and their respective messages.
class ContactPage extends StatefulWidget {
  
  /// The unique identifier of the user.
  final String uid1;

  ContactPage({required this.uid1});

  @override
  _ContactPageState createState() => _ContactPageState();
}

/// The state for the [ContactPage] widget.
class _ContactPageState extends State<ContactPage> {
  CustomColors? customColor;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? _avatarImage;

  /// The unique identifier of the current authenticated user.
  String get uid => _auth.currentUser!.uid;

  /// Fetches messages where the current user is a participant, excluding those marked as visible.

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchMessagesWithUid() {
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

  /// Marks a message as viewed by updating the unread count for the current user.
  ///
  /// [chatId] The unique identifier of the chat message.
  Future<void> setMessageAsViewed(String chatId) async {
    try {
      DocumentReference docRef =
          _firestore.collection('Private_Chat').doc(chatId);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('unreadCount') && data['unreadCount'] is Map) {
          Map<String, dynamic> unreadCount =
              Map<String, dynamic>.from(data['unreadCount']);
          unreadCount[uid] = 0;
          await docRef.update({'unreadCount': unreadCount});
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du message en vu : $e');
    }
  }

  Future<void> _loadAvatar() async {
    String? uid = Auth().currentUser?.uid;
    if (uid != null) {
      Uint8List? avatar = await AvatarService.getUserAvatar(uid);
      setState(() {
        _avatarImage = avatar;
      });
    }
  }

  /// Retrieves the unread count for a specific chat.
  ///
  /// [chatId] The unique identifier of the chat message.
  /// Returns the number of unread messages.
  Future<int> unreadCount(String chatId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Private_Chat').doc(chatId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('unreadCount') && data['unreadCount'] is Map) {
          int count = data['unreadCount'][uid] ?? 0;
          return count;
        }
      }
      return 0;
    } catch (e) {
      print(
          'Erreur lors de la récupération du nombre de messages non lus : $e');
      return 0;
    }
  }

  /// Retrieves the last message in the specified chat.
  ///
  /// [chatId] The unique identifier of the chat.
  /// Returns the last message as a string.
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

  /// Retrieves the last message date in the specified chat.
  ///
  /// [chatId] The unique identifier of the chat.
  /// Returns the last message date as a string formatted based on the current day.

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
        if (dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day) {
          formattedTime =
              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
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

  /// Hides the message from the user's view by updating the visibility field in Firestore.
  ///
  /// [chatId] The unique identifier of the chat.
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
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: customColor?.white?? Colors.white,),
          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
        child: Column(
          children: [
            Text(
              "MESSAGES",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 30,
                    color: customColor?.white?? Colors.white,),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              stream: _fetchMessagesWithUid(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('Erreur lors de la récupération des contacts'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                    snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Map<String, dynamic>> document =
                          documents[index];
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
                              foregroundColor: customColor?.white?? Colors.white,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FutureBuilder<Uint8List?>(
                                          future:
                                              AvatarService.getUserAvatar(uid2),
                                          builder: (context, avatarSnapshot) {
                                            if (avatarSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[800],
                                                radius: 35,
                                                child:
                                                    CircularProgressIndicator(),
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
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<DocumentSnapshot>(
                                            future: _firestore
                                                .collection('Users')
                                                .doc(uid2)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text(
                                                  'Chargement...',
                                                  style: TextStyle(
                                                      color: customColor?.white?? Colors.white,
                                                      fontSize: 16),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'Erreur',
                                                  style: TextStyle(
                                                      color: customColor?.white?? Colors.white,
                                                      fontSize: 16),
                                                );
                                              }
                                              if (!snapshot.hasData ||
                                                  !snapshot.data!.exists) {
                                                return Text(
                                                  'Utilisateur inconnu',
                                                  style: TextStyle(
                                                      color: customColor?.white?? Colors.white,
                                                      fontSize: 16),
                                                );
                                              }
                                              var userData =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    userData['pseudo'] ??
                                                        'Pseudo inconnu',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 17,
                                                          color: customColor?.white?? Colors.white,),
                                                    ),
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
                                                  builder: (context,
                                                      unreadSnapshot) {
                                                    return Text(
                                                      snapshot.data ??
                                                          'Aucun message',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        textStyle: TextStyle(
                                                            color: (unreadSnapshot
                                                                            .data ??
                                                                        0) >
                                                                    0
                                                                ? customColor?.white?? Colors.white
                                                                : customColor?.softWhite ??Colors.white70,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 14),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    );
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 10, top: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          FutureBuilder<String>(
                                            future: lastMessageDate(chatId),
                                            builder: (context, snapshot) {
                                              return Text(
                                                snapshot.data ?? '00:00',
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      color: customColor?.softWhite ??Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 13),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Center(
                                            child: FutureBuilder<int>(
                                              future: unreadCount(chatId),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return Text(
                                                    '!',
                                                    style: TextStyle(
                                                        color: customColor?.white?? Colors.white,),
                                                  );
                                                }
                                                int unreadCount =
                                                    snapshot.data ?? 0;
                                                return unreadCount > 0
                                                    ? Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            unreadCount
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  customColor?.white?? Colors.white,
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
