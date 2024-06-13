import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_message_package/voice_message_package.dart';

class chatmodel {
  String chatId;
  String Name;
  String senderId;
  String receiverId;
  String image;
  String message;
  DateTime time;
  messageType type;

  chatmodel(
      {required this.Name,
      required this.type,
      required this.chatId,
      required this.senderId,
      required this.receiverId,
      required this.image,
      required this.message,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'Name': Name,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'Image': image,
      'message': message,
      'time': time,
      'Type': type == messageType.text
          ? 'text'
          : type == messageType.video
              ? 'video'
              : type == messageType.voice
                  ? 'voice'
                  : 'image'
    };
  }

  factory chatmodel.fromMap(Map<String, dynamic> map) {
    return chatmodel(
        Name: map['Name'],
        chatId: map['chatId'],
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        image: map['Image'],
        message: map['message'],
        time: (map['time'] as Timestamp).toDate(),
        type: map['Type'] == 'text'
            ? messageType.text
            : map['Type'] == 'video'
                ? messageType.video
                : map['Type'] == 'voice'
                    ? messageType.voice
                    : messageType.image);
  }
}

enum messageType { text, image, video, voice }

class ChatImgProvider with ChangeNotifier {
  File? image;
  File? video;
  File? voiceChat;
  bool isRecording = false;

  setRecording(bool value) {
    isRecording = value;
    notifyListeners();
  }

  Future record() async {
    if (!isRecorderReady) return;
    setRecording(true);
    await recoder.startRecorder(toFile: 'audio');
  }

  Future<void> stop() async {
    if (!isRecorderReady) return;
    final path = await recoder.stopRecorder();
    debugPrint('File path: $path');
    voiceChat = File(path!);

    notifyListeners();
    setRecording(false);
    // await uploadAudioToFirebase(file, user, group, postData, commentUser);
  }

  Imagenull(File? image1) {
    image = image1;
    notifyListeners();
  }

  videonull(File? video1) {
    video = video1;
    notifyListeners();
  }

  FlutterSoundRecorder recoder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  // start() async {
  //   await record.;
  // }
  Future initRecoder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recoder.openRecorder();
    isRecorderReady = true;
    recoder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  pickvideo() async {
    ImagePicker pickvideo = ImagePicker();
    XFile? pickedvideo = await pickvideo.pickVideo(source: ImageSource.gallery);
    if (pickedvideo != null) {
      video = File(pickedvideo.path);
      notifyListeners();
    }
  }

  picker() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedimage = await picker.pickImage(source: ImageSource.camera);
    if (pickedimage != null) {
      image = File(pickedimage.path);
    }
    notifyListeners();
  }
}

class Bubble extends StatelessWidget {
  Bubble(
      {super.key,
      required this.img,
      required this.txt,
      required this.name,
      required this.me,
      required this.type});
  bool me;
  String name;
  String img;
  String txt;
  messageType type;
  @override
  Widget build(BuildContext context) {
    return me
        ? Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: type == messageType.text?
                 Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CircleAvatar(backgroundImage:NetworkImage(img),radius: 20,),
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: Colors.teal[900],
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.elliptical(-30, 50),
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                child: Text(
                                  txt,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ))),
                      ],
                    ),
                  )
                : type == messageType.video
                    ? Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          height: 200,
                                          child:CustomPlayer(videoplayer: txt),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )                  : type == messageType.voice
                        ? VoiceMessageView(
                          activeSliderColor: Colors.black54,
                            controller: VoiceController(
                              audioSrc: txt,
                              maxDuration: const Duration(seconds: 60),
                              isFile: false,
                              onComplete: () {},
                              onPause: () {},
                              onPlaying: () {},
                              onError: (err) {},
                            ),
                          )
                        : Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          height: 200,
                                          child: Image.network(txt),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
        : Padding(
            padding: const EdgeInsets.only(right: 50),
            child: type == messageType.text
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    //     margin: const EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(img),
                          radius: 27,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.elliptical(-30, 50),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: const TextStyle(
                                          color: Colors.yellow,
                                          fontFamily: 'Simple',
                                          fontSize: 20)),
                                  Text(
                                    txt,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                : type == messageType.video
                    ?Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              //     margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerRight,

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(img),
                                      radius: 27,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                       Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          height: 200,
                                          child:CustomPlayer(videoplayer: txt),
                                        ),
                                      ],
                                    )),
                                  ]),
                            ),
                          )
                    : type == messageType.voice
                        ? VoiceMessageView(
                          activeSliderColor: Colors.green,
                            controller: VoiceController(
                              audioSrc: txt,
                              maxDuration: const Duration(seconds: 60),
                              isFile: false,
                              onComplete: () {},
                              onPause: () {},
                              onPlaying: () {},
                              onError: (err) {},
                            ),
                          )
                        : Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              //     margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerRight,

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(img),
                                      radius: 27,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                       Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          height: 200,
                                          child: Image.network(txt),
                                        ),
                                      ],
                                    )),
                                  ]),
                            ),
                          ));
  }
}

class CustomPlayer extends StatefulWidget {
  CustomPlayer({super.key, required this.videoplayer});
  String videoplayer;
  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  late CachedVideoPlayerPlusController videocontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      videocontroller = CachedVideoPlayerPlusController.networkUrl(
          Uri.parse(widget.videoplayer));
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
    return InkWell(
      onTap: () {
        if (videocontroller.value.isPlaying) {
          videocontroller.pause();
        } else {
          videocontroller.play();
        }
       
      
        
      },
      child: Expanded(
        child: Container(
          height: 100,
          child: CachedVideoPlayerPlus(videocontroller),
        ),
      ),
    );
  }
}
