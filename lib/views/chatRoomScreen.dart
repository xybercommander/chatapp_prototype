import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
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
  String myUserName = "";

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {          
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}