import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/page/home_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:popover/popover.dart';
import 'package:makeitcode/widget/MenuItem.dart';
import 'package:makeitcode/page/private_message.dart';
import 'package:makeitcode/page/contact_page.dart';


class GlobalChatPage extends StatefulWidget {
  @override
  _GlobalChatPageState createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends State<GlobalChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String? pseudo;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null).then((_) {});
    getpseudo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

void getpseudo() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(Auth().uid).get();
      if (mounted) { 
        setState(() {
          pseudo = userDoc['pseudo'] ?? 'Anonyme';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération du pseudo : $e');
      if (mounted) {
        setState(() {
          pseudo = 'Anonyme';
        });
      }
    }
  } else {
    if (mounted) {
      setState(() {
        pseudo = 'Anonyme';
      });
    }
  }
}


  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        await _firestore.collection('global_chat').add({
          'date': Timestamp.now(),
          'uid': Auth().uid,
          'message': _controller.text,
          'pseudo': pseudo,
        });
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi du message.')),
        );
      }
    }
  }

  Widget _buildMessageItem(Map<String, dynamic> messageData) {
    final bool isCurrentUser = messageData['uid'] == Auth().uid;
    String formattedDate = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR')
        .format((messageData['date'] as Timestamp).toDate());

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    messageData['pseudo'] ?? 'Anonyme',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 20,
                    ),
                    onSelected: (String value) {
                      if (value == 'profil') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ouvrir la page de profil')),
                          );

                      } else if (value == 'message') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivateChatPage(
                                recipiaentuid: messageData['uid'] as String,
                              ),
                            ),
                          );
                        }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'profil',
                          child: Text('Profile'),
                        ),
                        PopupMenuItem(
                          value: 'message',
                          child: Text('Envoyer un message'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
            Text(
              messageData['message'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listenToMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('global_chat')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Aucun message pour le moment.'));
        }
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final messageData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return _buildMessageItem(messageData);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Chat global",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: Colors.white),
            padding: EdgeInsets.only(right: 50),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactPage(uid1: uid ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 113, 152, 1),
                    Color.fromARGB(255, 11, 22, 44)
                  ],
                  stops: [0.2, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _listenToMessages(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _controller,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Écrivez un message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
