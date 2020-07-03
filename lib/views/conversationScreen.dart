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
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return MessageTile(snapshot.data.documents[index].data["message"]);
          },
        );
      },
    );
  }


  sendMessage() {
    if(messaageController.text.isNotEmpty) {

      Map<String, String> messageMap = {
        "message" : messaageController.text,
        "sentBy" : Constants.myName
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
  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}