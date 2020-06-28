import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/views/chatRoomScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dataBaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();  
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  QuerySnapshot snapShotUserInfo;



  // Sing in method
  signIn() {
    if(formKey.currentState.validate()) {

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);      

      setState(() {
        isLoading = true;
      });

      dataBaseMethods.getUserByEmail(emailTextEditingController.text)
      .then((value) {
        snapShotUserInfo = value;
        HelperFunctions
          .saveUserNameSharedPreference(snapShotUserInfo.documents[0].data["name"]);        
      });      

      authMethods.signInWithEmailAndPassword
        (emailTextEditingController.text, passwordTextEditingController.text).then((value) {
          if(value != null) {            
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
            ));
          }
        });

    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(),
      body: isLoading ? 
      Container(
        child: Center(child: CircularProgressIndicator()),
      ) :
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(        
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                       TextFormField(
                        validator: (email) {
                          return RegExp(
                           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                         ).hasMatch(email) ?
                           null :
                           "Please provide a valid email id";
                        },
                        controller: emailTextEditingController,
                        style: simpleStyle(),
                        decoration: textFieldInputDecoration("email")
                      ),
                      TextFormField(
                        obscureText: showPassword == true ? false : true,
                        validator: (password){
                          return password.length > 6 ?
                            null : 
                            "Please provide a password which has more than 6 characters";
                        },
                        controller: passwordTextEditingController,
                        style: simpleStyle(),
                        decoration: textFieldInputDecoration("password")
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: Container(                        
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: showPassword ?
                            Text("Hide password", style: TextStyle(fontSize: 13, color: Colors.white38),) :
                            Text("Show password", style: TextStyle(fontSize: 13, color: Colors.white38),),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Forgot Password?", style: simpleStyle(),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff007EF4), Color(0xff2A75BC)]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign In", style: mediumStyle(Colors.white),),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign In with Google", style: mediumStyle(Colors.black),)
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ", style: mediumStyle(Colors.white)),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register Now", style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline 
                        )),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}