import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        return SearchTile(
          userName: searchSnapshot.documents[index].data["name"],
          userEmail: searchSnapshot.documents[index].data["email"],
        );
      }) : 
    Container();
  }


  /// create chatroom, send user to conversation screen, pushreplacement
  // createChatRoomAndStartConversation(String username) {

  //   List<String> user = [username, ];
  //   databaseMethods.createChatRoom(chatroomId, chatroomMap);
  // }


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



class SearchTile extends StatelessWidget {

  final userName;
  final userEmail;
  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
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
}