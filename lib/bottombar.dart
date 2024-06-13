

import 'package:app/calls.dart';
import 'package:app/setting.dart';
import 'package:app/userspage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class CustomBottomBar extends StatefulWidget {

   const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int currentIndex=0;

  PageController controller=PageController();

  void onPageChnaged(int index){
    setState(() {
      currentIndex=index;
    });
  }
  void onTap(int index){
   controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PageView(controller:controller,onPageChanged: onPageChnaged ,children: const [
      UserScreen(),
      Calls(),
      Setting( ),
      
      
    ],),bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
     
      currentIndex: currentIndex,onTap: onTap,items: const [
    BottomNavigationBarItem(
       activeIcon: Icon(Icons.message,color: Colors.teal,size: 40,),
      icon: Icon(
    Icons.message,color: Colors.black,
    ),
    label: 'Messages',
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.call,color: Colors.teal,size: 40,),
      icon: Icon(
    Icons.call,color: Colors.black,
    ),
    label:'Calls',
    ),

    BottomNavigationBarItem(
       activeIcon: Icon(Icons.settings,color: Colors.teal,size: 40,),
      icon: FaIcon(
    Icons.settings,color: Colors.black,
    ),
    label: 'Settings'
    ),
    ],),);
  }
}
