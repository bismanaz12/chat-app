import 'dart:async';
import 'dart:io';

import 'package:app/bottombar.dart';
import 'package:app/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  bool animate1 = false;
  bool animate2 = false;
  TextEditingController email_1 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController pass_1 = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  File? image;

  Future<String> downloadurl(File file) async {
    String id = const Uuid().v4();
    String url = '';
    FirebaseStorage firestor = FirebaseStorage.instance;
    await firestor
        .ref()
        .child('users')
        .child('$id.png')
        .putFile(file)
        .then((p0) async {
      url = await p0.ref.getDownloadURL();
    });
    return url;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [Colors.black, Color(0xff1B0E30), Colors.black])),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80, right: 70),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/cc.png',
                            height: 45,
                          ),
                          const Text(
                            'ChatBox',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Main',
                                fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, right: 150),
                      child: Text(
                        'Connect\nFriends',
                        style: TextStyle(color: Colors.white, fontSize: 65),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 160),
                      child: Text(
                        'Easily &\nQuickly',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Main',
                            fontSize: 65),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Our chat app is a perfect way to stay connected with friends and family_',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0, right: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              backgroundColor: Colors.transparent,
                              shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white)),
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              height: 60,
                              width: 50,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              backgroundColor: Colors.transparent,
                              shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white)),
                            ),
                            child: Image.asset(
                              'assets/images/face.png',
                              height: 60,
                              width: 50,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              backgroundColor: Colors.transparent,
                              shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white)),
                            ),
                            child: Image.asset(
                              'assets/images/apple.png',
                              height: 60,
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      '_______________  OR  _______________',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          animate1 = true;
                          animate2 = false;
                        });
                        // Get.to(()=>Signup(),transition: Transition.leftToRightWithFade,duration: Duration(seconds: 5));
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 50,
                          width: 300,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10, left: 40),
                            child: Text(
                              'Sign  up  within  Email',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Row(
                        children: [
                          const Text(
                            'Existing account ?',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                // Get.to(()=>Login());
                                setState(() {
                                  animate2 = true;
                                  animate1 = false;
                                });
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Main',
                                    fontSize: 20),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              // top: animate ? 20:0,
              left: animate1 ? 0 : -500,

              top: 80,

              duration: const Duration(seconds: 2),

              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                height: 580,
                width: 400,
                child: Column(children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 80.0),
                    child: Row(
                      children: [
                        Text(
                          'Sign up with',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Main',
                              fontSize: 25),
                        ),
                        Text(
                          ' Email',
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 60, right: 60),
                    child: Text(
                        'Get Chatting with Friends and Family Today by Signing up for our ChatApp'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // here is image

                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? pickedimage = await picker.pickImage(
                                source: ImageSource.camera);
                            if (pickedimage != null) {
                              image = File(pickedimage.path);
                            }
                            setState(() {});
                          },
                          child: image == null
                              ? const Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      radius: 25,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      ' Set your Image',
                                      style: TextStyle(
                                          color: Colors.teal, fontSize: 15),
                                    )
                                  ],
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 25,
                                )),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                    child: TextFormField(
                      controller: email_1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.teal,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        label: Text(
                          'Email',
                          style: TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Main',
                              fontSize: 20),
                        ),
                        //  prefixIcon: Icon(Icons.person,color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25.0, left: 30, right: 30),
                    child: TextFormField(
                      controller: name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        label: Text(
                          'Name',
                          style: TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Main',
                              fontSize: 20),
                        ),
                        //  prefixIcon: Icon(Icons.person,color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 30.0, right: 30),
                    child: TextFormField(
                      controller: pass_1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.teal,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        label: Text(
                          'Password',
                          style: TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Main',
                              fontSize: 20),
                        ),
                        //  prefixIcon: Icon(Icons.person,color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (email_1.text.isNotEmpty &&
                            name.text.isNotEmpty &&
                            pass_1.text.isNotEmpty) {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          FirebaseFirestore fire = FirebaseFirestore.instance;
                          String url = await downloadurl(image!);

                          UserCredential user =
                              await auth.createUserWithEmailAndPassword(
                                  email: email_1.text, password: pass_1.text);
                          Model usermodel = Model(
                              uid1: user.user!.uid,
                              email: email_1.text,
                              name: name.text,
                              password: pass_1.text,
                              imageurl: url);
                          fire
                              .collection('users')
                              .doc(user.user!.uid)
                              .set(usermodel.toMap());

                          //  showDialog(context: context, builder: (context)=>CusDialog());
                          setState(() {
                            animate1 = false;
                            animate2 = true;
                          });
                          email_1.clear();
                          pass_1.clear();
                          name.clear();
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40),
                        backgroundColor: Colors.teal,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        )),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Main',
                          fontSize: 25),
                    ),
                  )
                ]),
              ),
            ),

// nest login

            AnimatedPositioned(
              right: animate2 ? 0 : -500,
              top: 80,
              duration: const Duration(seconds: 2),
              child: Card(
                elevation: 10,
                shadowColor: Colors.white,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  height: 580,
                  width: 400,
                  child: Column(children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 80.0),
                      child: Row(
                        children: [
                          Text(
                            'Login into',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Main',
                                fontSize: 25),
                          ),
                          Text(
                            ' ChatApp',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 60, right: 60),
                      child: Text(
                          'Welcome back !  Login using your social account or email to continue with us'),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 70.0, right: 70, top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 80),
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 2)),
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              height: 60,
                              width: 50,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 80),
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 2)),
                            ),
                            child: Image.asset(
                              'assets/images/face.png',
                              height: 60,
                              width: 50,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 80),
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 2)),
                            ),
                            child: Image.asset(
                              'assets/images/appl.png',
                              height: 60,
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50.0, left: 30, right: 30),
                      child: TextFormField(
                        controller: email,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                          label: Text(
                            'Email',
                            style: TextStyle(
                                color: Colors.teal,
                                fontFamily: 'Main',
                                fontSize: 20),
                          ),
                          //  prefixIcon: Icon(Icons.person,color: Colors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 30.0, right: 30),
                      child: TextFormField(
                        controller: pass,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.teal,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                          label: Text(
                            'Password',
                            style: TextStyle(
                                color: Colors.teal,
                                fontFamily: 'Main',
                                fontSize: 20),
                          ),
                          //  prefixIcon: Icon(Icons.person,color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (email.text.isNotEmpty && pass.text.isNotEmpty) {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            UserCredential user =
                                await auth.signInWithEmailAndPassword(
                                    email: email.text, password: pass.text);
                            if (user.user != null) {
                              DocumentSnapshot<Map<String, dynamic>> snapshot =
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.user!.uid)
                                      .get();
                              ZegoUIKitPrebuiltCallInvitationService().init(
                                appID: 1663029138 /*input your AppID*/,
                                appSign:
                                    '6e17e25436ebb75f3873dc684df07e4583f90e4313b73be77f86c0431ab2c70e' /*input your AppSign*/,
                                userID: user.user!.uid,
                                userName: snapshot.data()!['name'],
                                plugins: [ZegoUIKitSignalingPlugin()],
                                
                                requireConfig: (ZegoCallInvitationData data) {
                                  final config = (data.invitees.length > 1)
                                      ? ZegoCallType.videoCall == data.type
                                          ? ZegoUIKitPrebuiltCallConfig
                                              .groupVideoCall()
                                          : ZegoUIKitPrebuiltCallConfig
                                              .groupVoiceCall()
                                      : ZegoCallType.videoCall == data.type
                                          ? ZegoUIKitPrebuiltCallConfig
                                              .oneOnOneVideoCall()
                                          : ZegoUIKitPrebuiltCallConfig
                                              .oneOnOneVoiceCall();

                                  // config.avatarBuilder = customAvatarBuilder;

                                  /// support minimizing, show minimizing button
                                  // config.topMenuBar.isVisible = true;
                                  // config.topMenuBar.buttons.insert(
                                  //     0,
                                  //     ZegoCallMenuBarButtonName
                                  //         .minimizingButton);

                                  return config;
                                },
                              );
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomBottomBar()),
                                  (route) => false);
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(250, 40),
                          backgroundColor: Colors.teal,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          )),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Main',
                            fontSize: 25),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ],
        ));
  }
}
