import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getUserByUsername(String username) async {
    return await Firestore.instance.collection("users")
      .where("name", isEqualTo: username)
      .getDocuments();
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance.collection("users")
      .where("email", isEqualTo: userEmail)
      .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }


  createChatRoom(String chatroomId, chatroomMap) {
    Firestore.instance.collection("ChatRoom")
      .document(chatroomId)
      .setData(chatroomMap).catchError((e) {
        print(e.toString());
      });
  }


  addConversationMessages(String chatroomId, messageMap) {
    Firestore.instance.collection("ChatRoom")
      .document(chatroomId)
      .collection("chats")
      .add(messageMap).catchError((e){print(e.toString());});
  }

   getConversationMessages(String chatroomId) async {
    return await Firestore.instance.collection("ChatRoom")
      .document(chatroomId)
      .collection("chats")
      .snapshots();
  }

}