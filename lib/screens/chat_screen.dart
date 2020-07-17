import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static  String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  
  final _auth = FirebaseAuth.instance;
 
  String messageText;


  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() async{
    try {
    final user = await _auth.currentUser();
    if(user != null){
      loggedInUser = user;
      print(loggedInUser.email);
     }
    }
    catch(e)
    {
      print(e);
    }
  }

  void messageStream() async {
       await for( var snapshot in  _firestore.collection('message').snapshots()){
      for (var  message in snapshot.documents) {
      print(message.data);
        }
      }
  }


  @override
  Widget build(BuildContext context) {
   // final _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              
              onPressed: () {
                messageStream();
  //              _auth.signOut();
   //             Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:messageController,
                      onChanged: (value) {
                        messageText = value;
                       
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageController.clear();
                    _firestore.collection('message').add({
                      'text':messageText,
                      'sender':loggedInUser.email,
                    });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
     
  class MessageStream extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
              stream:_firestore.collection('message').snapshots(),
             // This snapshot is a asynchronous snapshot 
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child:CircularProgressIndicator(
                       backgroundColor:Colors.blueAccent,
                    ),
                  );
                }
                  
                  final messages = snapshot.data.documents.reversed;
                //  This snapshot is async snapshot from flutter..
                  List<MessageBubble> messageWidgets = [];
                  for( var message in messages) {
                    final messageText = message.data['text'];
                    //this message is a document snapshot from firebase
                    final messageSender = message.data['sender'];
                    final currentUser = loggedInUser.email;

                  
                    final messageWidget = MessageBubble(messageSender,messageText,currentUser == messageSender);
                    messageWidgets.add(messageWidget);
                                   }//for
               return Expanded(
                                child: ListView(
                                  reverse: true,
                
                      children: messageWidgets,
                        
                    ),
               );
           }//builder
  
              //The builder will expect two parametere 1) context 2) Async method 
            );
    }
  }   
     
     
          class MessageBubble extends StatelessWidget {
            MessageBubble(this.sender,this.text,this.isMe);
           final String sender;
           final String text;
           final bool isMe;

                @override
                      Widget build(BuildContext context) {
                        return Padding(
                                padding: EdgeInsets.all(10.0),
                             child: Column(
                               crossAxisAlignment:isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
                               children:<Widget> [
                                 Text(sender,
                                 style: TextStyle(
                                   fontSize:12.0,
                                   color:Colors.black54,
                                 ),),
                                 Material(
                                   borderRadius: BorderRadius.only(
                                     topLeft:Radius.circular(30.0),
                                     bottomLeft:Radius.circular(30),
                                     bottomRight:Radius.circular(30),
                                     ),
                                   elevation:5.0,
                                    color:isMe ? Colors.blueAccent : Colors.white,
                                   child: Padding(
                                     padding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
                                  child: Text(
                                  text,
                                  style:TextStyle(
                                      fontSize:15.0,
                                      color: Colors.white,
                                  ),
                            ),
                                   ),
                          ),
                               ],
                             ),
                        );
                      }
                    }
              

