import 'package:app/bottombar.dart';
import 'package:app/classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        const SizedBox(height:60),
        Row(children: [
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomBottomBar()));
              },
              child: const Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
          ),
          const SizedBox(width: 100,),
          const Text('Settings',style: TextStyle(
            color: Colors.white,
            fontFamily: 'Main',
            fontSize: 30,
          ),)
        ],),
        const SizedBox(height: 60,),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(Provider.of<UserProvider>(context,listen: false).user!.imageurl),radius: 30,),
                      title: Text(Provider.of<UserProvider>(context,listen: false).user!.name,style: const TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 25),),
                      subtitle: Text(Provider.of<UserProvider>(context,listen: false).user!.email,style: const TextStyle(color: Colors.black,fontFamily: 'Simple',fontSize: 20),),
                      trailing: const Icon(Icons.qr_code_scanner,size: 35,),
                    ),
                  ),
                   Padding(
                     padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
                     child: CustomTile(txt1: 'Account', txt2: 'privacy,personalization', icon: Icons.key_off_outlined),
                   ),
                    Padding(
                     padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
                     child: CustomTile(txt1: 'Chat', txt2: 'themes,wallpaper', icon: Icons.message_outlined),
                   ),
                    Padding(
                     padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
                     child: CustomTile(txt1: 'Notification', txt2: 'privacy,personalization', icon: Icons.notification_add_outlined),
                   ),
                   
                     Padding(
                     padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
                     child: CustomTile(txt1: 'Help', txt2: 'help center,contact us',icon: Icons.help_center_outlined ),
                   ),
                     Padding(
                     padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
                     child: CustomTile(txt1: 'Data Storage', txt2: 'network usage,storage usage',icon: Icons.storage_outlined, ),
                   ),
                    Padding(
                     padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
                     child: CustomTile(txt1: 'Invite a Friend', txt2: '',icon: Icons.person_2_outlined, ),
                   ),
                    
              
                ],
              ),
            ),

          ),
        ),
       


      ]),
    );
  }
}






class CustomTile extends StatelessWidget {
   CustomTile({super.key,required this.txt1, required this.txt2, required this.icon,});
IconData icon;
String txt1;
String txt2;
  @override
  Widget build(BuildContext context) {
    return ListTile(
    leading: Icon(icon,color: const Color(0xffc7d0b4),size: 30,),
    title: Text(txt1,style: const TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 20),),
    subtitle: Text(txt2,style: const TextStyle(color: Color.fromARGB(255, 184, 186, 177),fontSize: 20,fontFamily: 'Simple'),),
    

    );
  }
}