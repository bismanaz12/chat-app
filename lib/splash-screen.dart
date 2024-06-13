// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app/bottombar.dart';
import 'package:app/first.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isanimate = false;

  Future start() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isanimate = true;
    });
    await Future.delayed(const Duration(seconds: 7));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context)=> FirebaseAuth.instance.currentUser!= null? const CustomBottomBar(): const First()));
  }

  @override
  void initState() {
    super.initState();
    start();
  //  getdata();

    //   Timer( Duration(seconds: 7) , () {

    //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signup()));
    //       //  Get.to(()=>Signup(),transition: Transition.circularReveal,duration: Duration(seconds: 10));

    //    });
  }
  // getdata() {
  //    if(FirebaseAuth.instance.currentUser !=null){
  //     Provider.of<UserProvider>(context,listen: false).getuserdata();
  //   }
  // }
  

  @override
  Widget build(BuildContext context) {
     
    
    return Stack(children: [
      Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/chat.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(seconds: 5),
        top: isanimate ? 600 : -150,
        left: isanimate ? 90 : -130,
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 100,
            child: Column(
              children: [
                Image.asset('assets/images/chaticon.png'),
                const Text(
                  'ChatApp',
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w700,
                      fontSize: 40),
                ),
              ],
            )),
      )
    ]);

    //
  }
}
