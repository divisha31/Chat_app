import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static  String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool showSpinner = false;
  
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
              child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                    tag : 'logo',
                    child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                email = value;

                  },
                decoration: KInputDecoration.copyWith( hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                 obscureText: true,
                 textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                
                  //Do something with the user input.
                },
                decoration: KInputDecoration.copyWith( hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),

              RoundedButton('Log In', Colors.lightBlueAccent,
               () async {
                 setState(() {
                 showSpinner = true;  
                 });
                 
                
                 
                 try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if(user != null)
                    {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                 showSpinner = false;  
                 });
                   }
                   catch(e){
                   print(e);
                   }
                    }, 
                 ),
            ],
          ),
        ),
      ),
    );
  }
}
