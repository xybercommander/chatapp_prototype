import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();

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
                  Container(
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}