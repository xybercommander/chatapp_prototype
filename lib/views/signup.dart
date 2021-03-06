import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:chat_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);


  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  bool showPassword = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  // Sign up Method
  signMeUp() {

    // method call for sending data to the firestore database            

    if(formKey.currentState.validate()){

      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text
      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);


      authMethods.signUpWithEmailAndPassword
        (emailTextEditingController.text, passwordTextEditingController.text).then((value){
          // print("${value.userId}");        

          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
          ));
        });


      setState(() {
        isLoading = true;
      });
    };   
    
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
                    children: <Widget>[
                      TextFormField(
                        validator: (username){
                          return username.isEmpty || username.length < 4 ?
                            "Please provide a valid Username" :
                            null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleStyle(),
                        decoration: textFieldInputDecoration("username")
                      ),
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
                        obscureText: showPassword ? false : true,
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
                    Spacer()                    
                  ],
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    signMeUp();
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
                    child: Text("Sign Up", style: mediumStyle(Colors.white),),
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
                  child: Text("Sign Up with Google", style: mediumStyle(Colors.black),)
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already? have an account? ", style: mediumStyle(Colors.white)),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Sign In now", style: TextStyle(
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