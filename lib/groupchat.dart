import 'dart:io';

import 'package:app/chatmodel.dart';
import 'package:app/chatscreen.dart';
import 'package:app/classes.dart';
import 'package:app/groupmodel.dart';
import 'package:app/groups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class GroupChat extends StatefulWidget {
   GroupChat({super.key,required this.group});
GroupModel group ;

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
TextEditingController  message = TextEditingController();

Future<String>downloadurl(File file)async{
String id = const Uuid().v4();
String url='';
FirebaseStorage firestor = FirebaseStorage.instance;
await firestor.ref().child('chats').child('$id.png').putFile(file).then((p0)async{
  url = await  p0.ref.getDownloadURL();
});
return url;
}

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: 
       AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
         
        
          
          title: 
        
           Row(children: [
            IconButton(onPressed: (){
            Navigator.pop(context);
          
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color:Colors.black)),
            CircleAvatar(backgroundImage:NetworkImage(widget.group.groupImage),radius: 30,),
            const SizedBox(width: 10,),
            Expanded(
              child: SizedBox(
                height: 40,width: 70,
                child: Text(widget.group.groupName,style: const TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'MyFont'),
                          
                ),
              ),
            ),
            const SizedBox(width: 60,),
            const Icon(Icons.video_call,color: Colors.black,size: 35),
            const SizedBox(width:5),
            const Icon(Icons.call,color: Colors.black,size: 35,),
            ]
            ,),


        ),

        body:
         Column(
          children: [
            Expanded(
              child: StreamBuilder(stream: FirebaseFirestore.instance.collection('groupchats').doc(widget.group.groupId).collection('messages').orderBy('time',descending: false).snapshots(),
               builder:(context,snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!.docs.isEmpty){
                    const Text('plz send message');
                          
                  }
                  return  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      var chat = snapshot.data!.docs[index].data();
                      
                     OurGroupChat groupchat =OurGroupChat.fromMap(chat);
                       return Bubble(img: groupchat.image, txt: groupchat.message, name:groupchat.Name, me: groupchat.senderId==FirebaseAuth.instance.currentUser!.uid?true:false, type:groupchat.type);
                      // return Text(chat['message'],style: TextStyle(color: Colors.black,fontSize: 18),);
                          
                          
                      }
                  );
                 
                          
                  }
                    return Center(child:SpinKitThreeBounce(color:Colors.blue,size:60));
               }
              ),
            ),

             const Divider(height: 20,thickness: 2,color: Colors.black,),
              if(Provider.of<ChatImgProvider>(context).image == null)
              Row(
              children: [
                  const Icon(Icons.keyboard_voice,color: Color.fromARGB(255, 7, 6, 6),size: 40,),
                SizedBox(
                  height: 50,width: 220,
                  
                  child: TextFormField(
                    
                    controller: message,
                    style: const TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 25),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      
                      
                    
                      hintStyle:TextStyle(color: Colors.grey,fontSize: 20),
                      hintText: 'Type message',

                        ),
                    
                  
                  ),
                ),
              
                         InkWell(
                          onTap: ()async{
                            
                            String chatId1 = const Uuid().v4();
                            var user11 = Provider.of<UserProvider>(context,listen: false).user;
                            String groupid = const Uuid().v4();
                        OurGroupChat chat = OurGroupChat(groupchatId: groupid, Name: user11!.name, senderId: FirebaseAuth.instance.currentUser!.uid, receiverId: widget.group.groupId, image: user11.imageurl, message: message.text, time:DateTime.now(), type:messageType.text);
                           await FirebaseFirestore.instance.collection('groupchats').doc(widget.group.groupId).collection('messages').doc(chatId1).set(chat.toMap());
                          message.clear();

                         
                          },
                          child: const Icon(Icons.send_outlined,color:Color.fromARGB(255, 7, 6, 6),size: 40,)),
                         const Icon(Icons.file_copy_outlined,color: Color.fromARGB(255, 7, 6, 6),size: 40,),
                          InkWell(
                          onTap: (){
                            Provider.of<ChatImgProvider>(context,listen: false).picker();
                          },
                          child: const Icon(Icons.camera_alt_outlined,color: Color.fromARGB(255, 7, 6, 6),size: 40,)),
                        
              ],
            )
             else
            SizedBox(
              height: 200,width: 250,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      
                       Provider.of<ChatImgProvider>(context,listen: false).image = null;
                       setState(() {
                         
                       });
                        
                        

                   
                    },
                    child: const Icon(Icons.cancel,color: Colors.black,size: 30,)),
                  Expanded(
                    child: SizedBox(
                      width: 200,height: 150,
                      child: Image.file(Provider.of<ChatImgProvider>(context).image!,fit: BoxFit.cover,)),
                  ),
                    IconButton(onPressed: ()async{
                       String chatId1 = const Uuid().v4();
                        var user11 = Provider.of<UserProvider>(context,listen: false).user;
                         var ImgProvider =Provider.of<ChatImgProvider>(context,listen: false);
                             String groupid = const Uuid().v4();
                       String url =await  downloadurl(ImgProvider.image!);
                            OurGroupChat chat = OurGroupChat(groupchatId: groupid, Name: user11!.name, senderId: FirebaseAuth.instance.currentUser!.uid, receiverId: widget.group.groupId, image: user11.imageurl, message: url, time:DateTime.now(), type:messageType.image);
                           await FirebaseFirestore.instance.collection('groupchats').doc(widget.group.groupId).collection('messages').doc(chatId1).set(chat.toMap());
                           ImgProvider.Imagenull(null);

                    }, icon: const Icon(Icons.send)),
                ],
              ),

            ),

             const Divider(height: 20,thickness: 2,color: Colors.black,),
if(Provider.of<ChatImgProvider>(context,listen: false).video != null)
   SizedBox(
                  height: 200,
                  width: 250,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:200),
                        child: InkWell(
                            onTap: () {
                              Provider.of<ChatImgProvider>(context, listen: false)
                                  .videonull(null);
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.black,
                              size: 30,
                            )),
                      ),
                      Player(
                          videoplayer: Provider.of<ChatImgProvider>(
                        context,
                      ).video!),
                      Padding(
                        padding: const EdgeInsets.only(left: 200.0),
                        child: IconButton(
                            onPressed: () async {
                              String chatId1 = const Uuid().v4();
                              var user1 = Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user;
                             
                        
                              String url = await downloadurl( Provider.of<ChatImgProvider>(context,
                                      listen: false).video!);
                              chatmodel mychat = chatmodel(
                                  type: messageType.video,
                                  Name: user1!.name,
                                  chatId: chatId1,
                                  senderId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  receiverId: widget.group.groupId,
                                  image: user1.imageurl,
                                  message: url,
                                  time: DateTime.now());
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(widget.group.groupId)
                                  .collection('messages')
                                  .doc(chatId1)
                                  .set(mychat.toMap());
                            Provider.of<ChatImgProvider>(context,listen: false).videonull(null);
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.black,
                              size: 30,
                            )),
                      ),
                    ],
                  ),),




          ]
         ),


     );
  }
}