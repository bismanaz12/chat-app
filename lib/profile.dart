


import 'package:app/classes.dart';
import 'package:app/first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
       body: Column(children: [
        const SizedBox(height: 40,),
        Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: Row(
          
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back,color: Colors.white,))
            ],
          ),
        ),
 
 Column(
  children: [
   ElevatedButton(
    onPressed: (){},
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white,width: 3)
      )
    ),
    child: CircleAvatar(backgroundImage: NetworkImage(Provider.of<UserProvider>(context,listen: false).user!.imageurl,),radius: 55,)),
    const SizedBox(height: 10,),
    Text(Provider.of<UserProvider>(context,listen: false).user!.name,style: const TextStyle(color: Colors.white,fontFamily: 'Simple',fontSize: 30),),
    
    Text(Provider.of<UserProvider>(context,listen: false).user!.email,style: const TextStyle(color: Color(0xffdce5e1)
,fontSize: 20,fontFamily: 'Chat'),),
    const SizedBox(height: 10,),
  ],
 ),

        Padding(
          padding: const EdgeInsets.only(left:30.0,right: 30),
          child: Row(
            children: [
              ElevatedButton(onPressed: (){}, 
              style: ElevatedButton.styleFrom(
               minimumSize: const Size(50, 50),
                shape: const CircleBorder(),
                backgroundColor: const Color(0xff313332)
              ),
              child:const Icon(Icons.message,color: Colors.white,size: 35,)),
               ElevatedButton(onPressed: (){}, 
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(50, 50),
                shape: const CircleBorder(),
                backgroundColor: const Color(0xff313332)
              ),
              child:const Icon(Icons.call,color: Colors.white,size: 35,)),
               ElevatedButton(onPressed: (){}, 
              style: ElevatedButton.styleFrom(
               minimumSize: const Size(50, 50),
                shape: const CircleBorder(),
                backgroundColor: const Color(0xff313332)
              ),
              child:const Icon(Icons.video_call,color: Colors.white,size: 35,)),
               ElevatedButton(onPressed: (){}, 
              style: ElevatedButton.styleFrom(
                 minimumSize: const Size(50, 50),
                shape: const CircleBorder(),
                backgroundColor: const Color(0xff313332)
              ),
              child:const Icon(Icons.more_horiz,color: Colors.white,size: 35,))
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:15.0,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                const SizedBox(height: 40,),
                    const Row(
                      children: [
                        Icon(Icons.star,color: Color(0xff939996),size: 20,),
                        Text('Display Name',style: TextStyle(color: Color(0xff939996),fontFamily: 'Simple',fontSize: 20),),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:25.0),
                      child: Text(Provider.of<UserProvider>(context,listen: false).user!. name,style: const TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 20),),
                    ),
                    const SizedBox(height: 20,),
                    const Row(
                      children: [
                        Icon(Icons.star,color: Color(0xff939996),size: 20,),
                        Text('Email Address',style: TextStyle(color: Color(0xff939996),fontFamily: 'Simple',fontSize: 20),),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:25.0),
                      child: Text(Provider.of<UserProvider>(context,listen: false).user!. email,style: const TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 20),),
                    ),
                     const SizedBox(height: 20,),
                    const Row(
                      children: [
                        Icon(Icons.star,color: Color(0xff939996),size: 20,),
                        Text('Address',style: TextStyle(color: Color(0xff939996),fontFamily: 'Simple',fontSize: 20),),
                      ],
                    ),
                     const SizedBox(height: 10,),
                     const Padding(
                      padding: EdgeInsets.only(left:25.0),
                      child: Text('Multan For Bad Luck',style: TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 20),),
                    ),
                     const SizedBox(height: 20,),
                      const Row(
                        children: [
                          Icon(Icons.star,color: Color(0xff939996),size: 20,),
                          Text('Phone Number',style: TextStyle(color: Color(0xff939996),fontFamily: 'Simple',fontSize: 20),),
                        ],
                      ),
                       const SizedBox(height: 10,),
                       const Padding(
                      padding: EdgeInsets.only(left:25.0),
                      child: Text('Kiyon Bataon',style: TextStyle(color: Colors.black,fontFamily: 'Main',fontSize: 20),),
                    ),
                    const SizedBox(height: 100,),
                      Row(
                       children: [
                         Icon(Icons.forward,color:Color(0xffdcdcde),size: 50,),
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(120, 30),
                            backgroundColor: const Color(0xffdcdcde),
                          shape:const RoundedRectangleBorder(
                            
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          )
                          ),
                          onPressed: ()async{
                          FirebaseAuth auth = FirebaseAuth.instance;
                          await auth.signOut();
                           ZegoUIKitPrebuiltCallInvitationService().uninit();
                         
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const First()));
                          // if(FirebaseAuth.instance.currentUser! .uid== null){
                            Provider.of<UserProvider>(context,listen: false).setUserNull(null);
                          // }

                         }, child: const Text('LogOut',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: 'Main'),)),
 
                         
                        
                       ],
                     ),
                     
              
              ]),
            ),
            
          ),
       ),
      
       
      ]
      ),
    );
  }
}