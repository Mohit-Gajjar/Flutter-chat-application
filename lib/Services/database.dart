import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoomId)
          .set(chatRoomMap)
          .catchError((e) {
        print(e.toString());
      });
    }
  }

  addConversationMessages(String chatroomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomId)
        .collection("chats")
        .add(messageMap)
        .then((value) {
      print(value.toString());
    });
  }

  getConversationMessages(String chatroomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getCharRooms(String name) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .orderBy("lastMessageSentTs", descending: true)
        .where("users", arrayContains: name)
        .snapshots();
  }

  updateLastMessage(
      String chatRoomId, Map<String, dynamic> lastMessageMap) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .update(lastMessageMap);
  }
}
