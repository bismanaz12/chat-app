import 'dart:io';
import 'package:app/chatmodel.dart';
import 'package:app/classes.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Chating extends StatefulWidget {
  const Chating({super.key, required this.receiverUser1});
  final Model receiverUser1;

  @override
  State<Chating> createState() => _ChatingState();
}

class _ChatingState extends State<Chating> {
  TextEditingController message = TextEditingController();

  Future<String> downloadurl(File file) async {
    String id = const Uuid().v4();
    String url = '';
    FirebaseStorage firestor = FirebaseStorage.instance;
    await firestor
        .ref()
        .child('chats')
        .child('$id.png')
        .putFile(file)
        .then((p0) async {
      url = await p0.ref.getDownloadURL();
    });
    return url;
  }

  String mergeId(String receiverId) {
    return FirebaseAuth.instance.currentUser!.uid.hashCode <=
            receiverId.hashCode
        ? '${FirebaseAuth.instance.currentUser!.uid}_$receiverId'
        : '${receiverId}_${FirebaseAuth.instance.currentUser!.uid}';
  }

  @override
  Widget build(BuildContext context) {
    var voiceProvider = Provider.of<ChatImgProvider>(context);
    voiceProvider.initRecoder();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.black)),
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.receiverUser1.imageurl),
                radius: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.receiverUser1.name,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'MyFont'),
              ),
            ],
          ),
           
          actions: [
            ZegoSendCallInvitationButton(
           
              buttonSize: Size(50, 50),
              iconSize: Size(40,40),
              isVideoCall: true,
              resourceID:
                  "chat_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
              invitees: [
                ZegoUIKitUser(
                  id: widget.receiverUser1.uid1,
                  name: widget.receiverUser1.name,
                ),
              ],
            ),
            ZegoSendCallInvitationButton(
               buttonSize: Size(50, 50),
                 iconSize: Size(40,40),
              isVideoCall: false,
              resourceID:
                  "chat_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
              invitees: [
                ZegoUIKitUser(
                  id: widget.receiverUser1.uid1,
                  name: widget.receiverUser1.name,
                ),
              ],
            )
          ],
        
        ),
        body: WillPopScope(
          onWillPop: () async {
            return ZegoUIKit().onWillPop(context);
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(mergeId(widget.receiverUser1.uid1))
                        .collection('messages')
                        .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          const Text('plz send message');
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var chat = snapshot.data!.docs[index].data();
                              chatmodel mychat = chatmodel.fromMap(chat);

                              return Bubble(
                                type: mychat.type,
                                img: widget.receiverUser1.imageurl,
                                txt: mychat.message,
                                name: widget.receiverUser1.name,
                                me: mychat.senderId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? true
                                    : false,
                              );
                              // return Text(chat['message'],style: TextStyle(color: Colors.black,fontSize: 18),);
                            });
                      }
                      return Center(
                        child:SpinKitChasingDots(color: Color.fromARGB(255, 2, 27, 49)
                        )

                      );
                    }),
              ),

              const Divider(
                height: 20,
                thickness: 2,
                color: Colors.black,
              ),
              if (Provider.of<ChatImgProvider>(context).video == null)
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!voiceProvider.isRecorderReady) {
                          voiceProvider.initRecoder();
                        }
                        if (voiceProvider.recoder.isRecording) {
                          voiceProvider.stop();
                          String chatId1 = const Uuid().v4();
                          var user1 =
                              Provider.of<UserProvider>(context, listen: false)
                                  .user;
                          String url =
                              await downloadurl(voiceProvider.voiceChat!);
                          chatmodel mychat = chatmodel(
                              type: messageType.voice,
                              Name: user1!.name,
                              chatId: chatId1,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              receiverId: widget.receiverUser1.uid1,
                              image: user1.imageurl,
                              message: url,
                              time: DateTime.now());
                          await FirebaseFirestore.instance
                              .collection('chats')
                              .doc(mergeId(widget.receiverUser1.uid1))
                              .collection('messages')
                              .doc(chatId1)
                              .set(mychat.toMap());
                        } else {
                          voiceProvider.record();
                        }
                      },
                      child: const Icon(
                        Icons.keyboard_voice,
                        color: Color.fromARGB(255, 7, 6, 6),
                        size: 40,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 220,
                      child: TextFormField(
                        controller: message,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Main',
                            fontSize: 25),
                        decoration: const InputDecoration(
                          border: InputBorder.none,

                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          hintText: 'Type message',

                          // focusedBorder: UnderlineInputBorder(

                          // borderSide: BorderSide(color: Colors.black,width: 1)
                          // ),
                          // enabledBorder: UnderlineInputBorder(

                          // borderSide: BorderSide(color: Colors.black,width: 1)
                          // ),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          String chatId1 = const Uuid().v4();
                          var user1 =
                              Provider.of<UserProvider>(context, listen: false)
                                  .user;

                          chatmodel mychat = chatmodel(
                              type: messageType.text,
                              Name: user1!.name,
                              chatId: chatId1,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              receiverId: widget.receiverUser1.uid1,
                              image: user1.imageurl,
                              message: message.text,
                              time: DateTime.now());
                          await FirebaseFirestore.instance
                              .collection('chats')
                              .doc(mergeId(widget.receiverUser1.uid1))
                              .collection('messages')
                              .doc(chatId1)
                              .set(mychat.toMap());
                          message.clear();
                        },
                        child: const Icon(
                          Icons.send_outlined,
                          color: Color.fromARGB(255, 7, 6, 6),
                          size: 40,
                        )),
                    InkWell(
                        onTap: () {
                          Provider.of<ChatImgProvider>(context, listen: false)
                              .pickvideo();
                        },
                        child: const Icon(
                          Icons.file_copy_outlined,
                          color: Color.fromARGB(255, 7, 6, 6),
                          size: 40,
                        )),
                    InkWell(
                        onTap: () {
                          Provider.of<ChatImgProvider>(context, listen: false)
                              .picker();
                        },
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Color.fromARGB(255, 7, 6, 6),
                          size: 40,
                        )),
                  ],
                )
              else
                SizedBox(
                  height: 200,
                  width: 250,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:100),
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
                        padding: const EdgeInsets.only(left: 100.0),
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
                                  receiverId: widget.receiverUser1.uid1,
                                  image: user1.imageurl,
                                  message: url,
                                  time: DateTime.now());
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(mergeId(widget.receiverUser1.uid1))
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
                  ),
                ),

              if(Provider.of<ChatImgProvider>(context).image != null)
              Container(
                height: 200,width: 250,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: InkWell(
                        onTap: (){
                      
                           Provider.of<ChatImgProvider>(context,listen: false).image = null;
                           setState(() {
                      
                           });
                      
                        },
                        child: Icon(Icons.cancel,color: Colors.black,size: 30,)),
                    ),
                    Expanded(
                      child: Container(
                        width: 200,height: 150,
                        child: Image.file(Provider.of<ChatImgProvider>(context).image!,fit: BoxFit.cover,)),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(left:100.0),
                        child: IconButton(onPressed: ()async{
                         
                           String chatId1 = Uuid().v4();
                            var user1 = Provider.of<UserProvider>(context,listen: false).user;
                             var ImgProvider =Provider.of<ChatImgProvider>(context,listen: false);
                        
                           String url =await  downloadurl(ImgProvider.image!);
                               chatmodel mychat = chatmodel(type: messageType.image,Name:user1!.name ,chatId: chatId1, senderId:FirebaseAuth.instance.currentUser!.uid, receiverId: widget.receiverUser1.uid1, image: user1.imageurl, message:url, time:DateTime.now() );
                               await FirebaseFirestore.instance.collection('chats').doc(mergeId(widget.receiverUser1.uid1)).collection('messages').doc(chatId1).set(mychat.toMap());
                               ImgProvider.Imagenull(null);
                        
                        }, icon: Icon(Icons.send,color: Colors.black,size: 30,)),
                      ),
                  ],
                ),

              ),
              const Divider(
                height: 20,
                thickness: 2,
                color: Colors.black,
              ),
            ],
          ),
        ));
  }
}

class Player extends StatefulWidget {
  Player({super.key, required this.videoplayer});
  File videoplayer;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late CachedVideoPlayerPlusController videocontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      videocontroller =
          CachedVideoPlayerPlusController.file(widget.videoplayer);
    });
    videocontroller.initialize();
    videocontroller.play();
    videocontroller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:100,
      width:150,
      child: CachedVideoPlayerPlus(videocontroller));
  }
}
