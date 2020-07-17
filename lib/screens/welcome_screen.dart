import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/screens/round_button.dart';

class WelcomeScreen extends StatefulWidget {
 static  String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
//adding singleTicker with pur class add funtionlity of ticker in our class object .
  AnimationController controller;
 Animation animation;

  @override 
  void initState(){
    super.initState();
    //Creating a animation controller and saving it in a controller property.

    controller = AnimationController(
      duration: Duration(seconds: 30),
      vsync: this,
      //it means its going to be the current class object  )
    );

 animation = ColorTween(begin:Colors.blueGrey,end:Colors.white).animate(controller);
// animation = CurvedAnimation(parent:controller ,curve:Curves.decelerate);
    controller.forward();

  /*  animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller.reverse(from:1.0);

      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
      //To make increase and decrease the height of logo;
    }); */

    controller.addListener((){
      setState(() {
      });
      print(animation.value );
    });
  } 

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
    //  backgroundColor: Colors.greenAccent.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // 
          children: <Widget>[
            Row(
              children: <Widget>[
              Hero(
                tag:'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60
                    ,
                  ),
                ),
                 ColorizeAnimatedTextKit(
                  text: ["Flash Chat"],
                  colors:[Colors.blue,Colors.green,Colors.red],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
           
    RoundedButton('Log In',Colors.blueAccent,
           () {
             Navigator.pushNamed(context, LoginScreen.id);
           }),

    RoundedButton('Register',Colors.lightGreenAccent,
           () {
             Navigator.pushNamed(context, RegistrationScreen.id);
           }),
          ],
        ),
      ),
    );
  }
}

