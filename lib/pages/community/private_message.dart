import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateChatPage extends StatefulWidget {
  final String recipiaentuid;

  PrivateChatPage({required this.recipiaentuid});

  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final player = AudioPlayer();
  String? senderPseudo;
  String? recipientPseudo;


  String _getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null).then((_) {});
    _initializeChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


Future<void> _initializeChat() async {
  String senderUid = Auth().uid!;
  String recipientUid = widget.recipiaentuid;

  try {
    DocumentSnapshot<Map<String, dynamic>> senderDoc =
        await _firestore.collection('Users').doc(senderUid).get();
    DocumentSnapshot<Map<String, dynamic>> recipientDoc =
        await _firestore.collection('Users').doc(recipientUid).get();

    if (mounted) { 
      setState(() {
        senderPseudo = senderDoc.data()?['pseudo'] ?? 'Anonyme';
        recipientPseudo = recipientDoc.data()?['pseudo'] ?? 'Anonyme';
      });
    }

    String chatId = _getChatId(senderUid, recipientUid);
    await _firestore.collection('Private_Chat').doc(chatId).set({
      'participants': [senderUid, recipientUid],
    }, SetOptions(merge: true));
  } catch (e) {
    print('Erreur lors de l\'initialisation de la conversation : $e');
  }
}

  Widget _listenToMessages() {
    String chatId = _getChatId(Auth().uid!, widget.recipiaentuid);
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Private_Chat')
          .doc(chatId)
          .collection('messages')
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
            Text(
              messageData['pseudo'] ?? 'Anonyme',
              style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 15,color: Colors.black),),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              messageData['message'] ?? '',
            style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,fontSize: 14),)),
            SizedBox(height: 5),
            Text(
              formattedDate,
               style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,fontSize: 10),)),
          ],
        ),
      ),
    );
  }
    void _sendMessage() async {
      if (_controller.text.isNotEmpty) {
        String chatId = _getChatId(Auth().uid!, widget.recipiaentuid);
        player.play(AssetSource('sound/sent_message.wav'));
        try {
          
          DocumentReference chatDoc = _firestore.collection('Private_Chat').doc(chatId);
          DocumentSnapshot chatSnapshot = await chatDoc.get();

          Map<String, dynamic>? unreadCountData = (chatSnapshot.data() as Map<String, dynamic>?)?['unreadCount'] as Map<String, dynamic>? ?? {};
          
          unreadCountData[widget.recipiaentuid] = (unreadCountData[widget.recipiaentuid] ?? 0) + 1;

          await chatDoc.collection('messages').add({
            'date': Timestamp.now(),
            'uid': Auth().uid,
            'message': _controller.text,
            'pseudo': senderPseudo ?? 'Utilisateur',
          });
          await chatDoc.update({
            'unreadCount': unreadCountData,
          });
            await chatDoc.update({
            'visibility': FieldValue.delete(),
            });
          _controller.clear();
          
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'envoi du message : $e')),
          );
        }
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(recipientPseudo ?? 'Chargement ...', style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color:Color.fromARGB(255, 11, 22, 44),
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
