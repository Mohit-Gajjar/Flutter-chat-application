import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Helper/constants.dart';
import 'package:simplelogin/Services/database.dart';
import 'package:simplelogin/views/conversation_screens.dart';

class SearchUser extends StatefulWidget {
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot;
  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userEmail: searchSnapshot!.docs[index]["email"],
                username: searchSnapshot!.docs[index]["name"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getUserByName(searchEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoom({required String userName}) {
    if (userName != Constants.myName) {
      print(userName + " " + Constants.myName);
      String charRoomIdentity = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": charRoomIdentity
      };
      DatabaseMethods().createChatRoom(charRoomIdentity, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Conversation(
                  chatroomId: charRoomIdentity, username: userName)));
    } else {
      print("you cannot message to yourself");
    }
  }

// ignore: non_constant_identifier_names
  Widget SearchTile({required String username, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: GestureDetector(
        onTap: () => createChatRoom(userName: username),
        child: Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                child: Text(
                  username[0],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(userEmail,
                      style: TextStyle(color: Colors.white, fontSize: 18))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff191720),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Search",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
          ),
        ),
        body: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color(0xFF3152BD),
                ),
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: TextField(
                onSubmitted: initiateSearch(),
                controller: searchEditingController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Users",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          searchList(),
        ]));
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
