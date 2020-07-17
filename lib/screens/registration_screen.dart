import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/round_button.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static  String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  //this auth object we used to create a user with email and password 
  String email;
  String password;
  bool showSpinner = false;
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
            Flexible(
                  child: Hero(
                  tag:'logo',
                   child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
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
                  //Do something with the user input.
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
                decoration: KInputDecoration.copyWith( hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton('Register',Colors.white,
             () async {
               setState(() {
                 showSpinner = true;
               });
               print(email);
               print(password);
               try{
               final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
               if(newUser != null){
                 Navigator.pushNamed(context, ChatScreen.id);
               }
               setState(() {
                 showSpinner = false;
               });
               
               }
               catch(e){
                 print(e);
               }
             }),
            ],
          ),
        ),
      ),
    );
  }
}
