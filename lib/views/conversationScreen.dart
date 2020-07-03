import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  ConversationScreen(this.chatroomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  

  DatabaseMethods dataBaseMethods = new DatabaseMethods();
  TextEditingController messaageController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return MessageTile(snapshot.data.documents[index].data["message"],
              snapshot.data.documents[index].data["sentBy"] == Constants.myName);
          },
        ) : Container();
      },
    );
  }


  sendMessage() {
    if(messaageController.text.isNotEmpty) {

      Map<String, dynamic> messageMap = {
        "message" : messaageController.text,
        "sentBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };

      dataBaseMethods.addConversationMessages(widget.chatroomId, messageMap);
      messaageController.text = "";
    }
  }


  @override
  void initState() {
    dataBaseMethods.getConversationMessages(widget.chatroomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: appBarMain(),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messaageController,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(
                          color: Colors.white54
                        ),
                        border: InputBorder.none
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
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
                      child: Image.asset("assets/images/send.png")
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.only(left: isSentByMe ? 0 : 20, right:  isSentByMe ? 20 : 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe ? [
              Color(0xff007Ef4),
              Color(0xff2A75BC),
            ] : [
              Color(0x1AFFFFFF),
              Color(0x1AFFFFFF),
            ]
          ),
          borderRadius: isSentByMe ?
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ) :
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23),
            )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        ),),
      ),
    );
  }
}