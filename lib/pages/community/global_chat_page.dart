import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:makeitcode/pages/community/private_message.dart';
import 'package:makeitcode/pages/community/list_message_page.dart';
import 'package:makeitcode/pages/profil/open_profil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/pages/web_view/loadWebView.dart'; // Add this import


/// GlobalChatPage is a StatefulWidget that represents the user interface for a global chat.
/// It manages sending and receiving messages in real-time using Firestore.
class GlobalChatPage extends StatefulWidget {
  const GlobalChatPage({super.key});

  @override
  _GlobalChatPageState createState() => _GlobalChatPageState();
}

/// _GlobalChatPageState manages the state of the GlobalChatPage.
/// It includes functionality for sending messages, displaying messages,
/// and managing user authentication and profile details.
class _GlobalChatPageState extends State<GlobalChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final player = AudioPlayer();
  String? pseudo;

  /// This method is called when the widget is initialized.
  /// It sets up the date formatting and fetches the user's pseudo from Firestore.
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null).then((_) {});
    getpseudo();
  }

  /// Disposes of the TextEditingController when the widget is destroyed.
  /// This helps avoid memory leaks by properly cleaning up resources.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/// Fetches the user's pseudo from Firestore and updates the state.
/// If the user has a pseudo stored, it will be used; otherwise, 'Anonyme' is used as a fallback.
/// This information is stored in Firestore under the 'Users' collection.
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
  }
 }
}
  /// Sends a message to the global chat collection in Firestore.
  /// If the input text is not empty, it plays a sound effect and stores the message in Firestore.
  /// The message includes the current timestamp, user ID, and pseudo.
  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      player.play(AssetSource('sound/sent_message.wav'));
      try {
        await _firestore.collection('global_chat').add({
          'date': Timestamp.now(),
          'uid': Auth().uid,
          'message': _controller.text,
          'pseudo': pseudo,
        });
        // Clears the message input field after sending the message.
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi du message.')),
        );
      }
    }
  }

  /// Builds a widget for displaying a single message from the global chat.
  /// It checks whether the message belongs to the current user and displays it accordingly.
  /// Also formats the date for display in the message.
  ///
  /// @param messageData The data for a single message retrieved from Firestore.
  /// @return A widget that displays the message content.
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
                    style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 15),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 20,
                    ),
                    onSelected: (String value) {
                      if (value == 'profil') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpenProfilePage(
                                uid: messageData['uid'] as String,
                              ),
                            ),
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
                          child: Text('Profil'),
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
              style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,fontSize: 14),),
            ),
            SizedBox(height: 5),
            Text(
              formattedDate,
              style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,fontSize: 10),),
            ),
          ],
        ),
      ),
    );
  }

  /// Listens for new messages in the global chat by listening to changes in the Firestore collection.
  /// Displays the messages in a ListView, with the latest messages appearing at the top.
  /// 
  /// @return A widget that listens to the 'global_chat' collection and displays the messages.
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
  /// Builds the user interface for the GlobalChatPage.
  /// It includes the AppBar, message input field, and the list of messages.
  /// 
  /// @return The widget tree for the GlobalChatPage.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CHAT GLOBAL",
          style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),),

        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: Colors.white),
            padding: EdgeInsets.only(right: 40),
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
        leading: IconButton(
          icon: Icon(Icons.bug_report, color: Colors.white),
          onPressed: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebViewPage()),
              );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(0, 113, 152, 1),
                  Color.fromARGB(255, 11, 22, 44),
                ],
                stops: [0.1, 0.9],
                center: Alignment(-0.7, 0.7),
                radius: 0.8,
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
