import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dataBaseMethods = new DatabaseMethods();
  String myUserName = "";

  Stream chatRoomStream;


  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return ChatRoomTile(snapshot.data.documents[index].data["chatroomId"]
              .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
              snapshot.data.documents[index].data["chatroomId"]
            );
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();    
    super.initState();
  }

  getUserInfo() async {
    myUserName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      Constants.myName = myUserName;
    });
    dataBaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Color.fromRGBO(20, 82, 146, 1),    
        title: Image.asset("assets/images/chatapp .jpg", height: 90,),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app)
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {          
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}


class ChatRoomTile extends StatelessWidget {

  final String username;
  final String chatRoom;
  ChatRoomTile(this.username, this.chatRoom);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoom)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff007EF4), Color(0xff2A75BC)]
                ),
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${username.substring(0, 1)}", style: mediumStyle(Colors.white),),
            ),
            SizedBox(width: 8,),
            Text(username, style: mediumStyle(Colors.white),)
          ],
        ),
      ),
    );
  }
}