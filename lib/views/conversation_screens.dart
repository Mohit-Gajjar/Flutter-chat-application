import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Helper/constants.dart';
import 'package:simplelogin/Services/database.dart';

class Conversation extends StatefulWidget {
  final String chatroomId;
  final String username;
  Conversation({required this.chatroomId, required this.username});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream? chatMessageStream;

  // ignore: non_constant_identifier_names
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return MessageTile(
                          isSendByMe: ds["sendBy"] == Constants.myName,
                          message: ds["message"],
                          timeStamp: ds["time"].toDate(),
                        );
                      }),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      messageController.text.trim().trimLeft().trimRight();
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": lastMessageTs
      };
      DatabaseMethods().addConversationMessages(widget.chatroomId, messageMap);
      Map<String, dynamic> lastMessageMap = {
        "lastMessage": messageController.text,
        "lastMessageSentTs": lastMessageTs,
        "lastMessageSentBy": Constants.myName
      };
      DatabaseMethods().updateLastMessage(widget.chatroomId, lastMessageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatroomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: GestureDetector(
              onTap: () {},
              child: Container(
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          "${widget.username.substring(0, 1).toUpperCase()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            )),
        body: Container(
            margin: EdgeInsets.only(bottom: 60),
            height: MediaQuery.of(context).size.height,
            child: ChatMessageList()),
        bottomSheet: Container(
          color: Color(0xff191720),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Color(0xff191720),
                height: 60,
                width: MediaQuery.of(context).size.width - 85,
                child: Card(
                  color: Color(0xff191720),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(width: 2, color: Colors.white54)),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        minLines: 1,
                        controller: messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.white30,
                            fontSize: 18,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  sendMessage();
                  setState(() {
                    messageController.clear();
                  });
                },
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Color(0xFF90B637),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.send_outlined,
                      color: Colors.black45,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  DateTime timeStamp;
  // var t1 = DateTime.parse(time);
  // var timeStamp = DateFormat('jm').format(time);

  MessageTile(
      {Key? key,
      required this.message,
      required this.isSendByMe,
      required this.timeStamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: isSendByMe ? 0 : 16,
          right: isSendByMe ? 16 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft:
                      isSendByMe ? Radius.circular(15) : Radius.circular(0),
                  bottomRight:
                      isSendByMe ? Radius.circular(0) : Radius.circular(15)),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 6),
              child: Text(message,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
          Text(timeStamp.hour.toString() + ":" + timeStamp.minute.toString(),
              style: TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }
}
