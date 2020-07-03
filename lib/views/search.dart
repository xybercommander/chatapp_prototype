import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/helperfunctions.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  
  QuerySnapshot searchSnapshot;

  initiateSearch() {
   databaseMethods
      .getUserByUsername(searchTextEditingController.text)
      .then((val) {
        setState(() {
          searchSnapshot = val;          
        });
      });
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.documents.length,
      itemBuilder: (context, index) {
        return searchTile(
          userName: searchSnapshot.documents[index].data["name"],
          userEmail: searchSnapshot.documents[index].data["email"],
        );
      }) : 
    Container();
  }



  /// create chatroom, send user to conversation screen, pushreplacement
  createChatRoomAndStartConversation({String username}) async {    
    
    String chatRoomId = getChatroomId(username, Constants.myName);

    List<String> users = [username, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "chatroomId" : chatRoomId
    };

    await DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(chatRoomId)
    ));
       
  }



  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName, style: simpleStyle()),
              Text(userEmail, style: simpleStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff007EF4), Color(0xff2A75BC)]
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: mediumStyle(Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  

  getUserInfo() async {
    print(Constants.myName);    
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "search username...",
                        hintStyle: TextStyle(
                          color: Colors.white54
                        ),
                        border: InputBorder.none
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();                      
                      // print(searchTextEditingController.text);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0x36FFFFFF), Color(0X0FFFFFFF)]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),                    
                      child: Image.asset("assets/images/search_white.png")
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}



getChatroomId(String a, String b) {
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }  
}
