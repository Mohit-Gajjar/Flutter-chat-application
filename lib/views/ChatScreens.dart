import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Helper/constants.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/Services/Authentication_services.dart';
import 'package:simplelogin/Services/database.dart';
import 'package:simplelogin/views/conversationScreens.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
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
                      ds.id
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.docs[index]["chatroomId"], snapshot.data.docs[index]["lastMessage"]);
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
    return Scaffold(
        backgroundColor: Color(0xFF160623),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Chats",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
          ),
        ),
        body: Container(child: chatRoomList()));
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatroomId;
  final String lastMessageTs;
  ChatRoomTile(this.username, this.chatroomId, this.lastMessageTs);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Conversation(
                      chatroomId: chatroomId,
                      username: username,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          children: [
            Center(
              child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    "${username.substring(0, 1).toUpperCase()}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  lastMessageTs,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
