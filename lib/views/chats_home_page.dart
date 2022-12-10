import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplelogin/Helper/constants.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/Services/Authentication_services.dart';
import 'package:simplelogin/Services/database.dart';
import 'package:simplelogin/views/conversation_screens.dart';

class ChatsHomePage extends StatefulWidget {
  @override
  _ChatsHomePageState createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream? chatRoomStream;

  Widget chatRoomList() => StreamBuilder(
      stream: chatRoomStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ChatRoomTile(
                    ds.id.replaceAll("_", "").replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index]["chatroomId"],
                    snapshot.data.docs[index]["lastMessageSentTs"],
                    snapshot.data.docs[index]["lastMessage"],
                  );
                })
            : Container();
      });

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethods.getCharRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('assets/back.png')),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Chats",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
            ),
          ),
          body: Container(child: chatRoomList())),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatroomId;
  final String lastMessage;
  final Timestamp lastMessageTs;
  ChatRoomTile(
      this.username, this.chatroomId, this.lastMessageTs, this.lastMessage);
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        lastMessageTs.millisecondsSinceEpoch);
    var formattedDate = DateFormat.yMMMd().format(date);
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Conversation(
                      chatroomId: chatroomId,
                      username: username,
                    )));
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          "${username.substring(0, 1).toUpperCase()}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            username,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Spacer(),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
      subtitle: Text(
        lastMessage,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 16,
        ),
      ),
    );
  }
}
