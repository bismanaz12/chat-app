import 'package:app/bottombar.dart';
import 'package:app/chatmodel.dart';
import 'package:app/classes.dart';
import 'package:app/groupchat.dart';
import 'package:app/groupmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyGroups extends StatelessWidget {
   const MyGroups({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        const SizedBox(height: 50,),
        Padding(
          padding: const EdgeInsets.only(right: 330),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomBottomBar()));
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,size: 30,)),
        ),
        const SizedBox(height: 20,),
        const Text('Group Friends',style: TextStyle(color: Colors.white,fontFamily: 'Main',fontSize: 30),),
        const SizedBox(height: 50,),
        Expanded(child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
        child: StreamBuilder(stream:FirebaseFirestore.instance.collection('groups') .where('members',arrayContains: FirebaseAuth.instance.currentUser!.uid).        snapshots() , builder: ((context, snapshot){
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
            if(snapshot.hasData){
              if(snapshot.data!.docs.isEmpty){
                const Text('Oyy Add Group ');
              }
              var data = snapshot.data!.docs[index].data();
               GroupModel groupmodel = GroupModel.fromMap(data);
              return InkWell(
                onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>GroupChat(group: groupmodel,)));
                },
                child: UserContainer(groupmodel.groupImage,groupmodel.groupName));
            }
            return const Center(child:SpinKitDoubleBounce(color:Color.fromARGB(255, 3, 39, 70)),);
          });
        })),
        ))
      ]),
    );
  
}
}






class OurGroupChat{

 String groupchatId;
String Name;
String senderId;
String receiverId;
String image;
String message;
DateTime time;
messageType type;

OurGroupChat({required this.groupchatId,required this.Name,required this.senderId,required this.receiverId,required this.image,required this.message,required this.time,required this.type});
  Map<String,dynamic>toMap(){
return {
'groupchatId':groupchatId,
'Name':Name,
'senderId':senderId,
'receiverId':receiverId,
'Image':image,
'message':message,
'time':time,
'type':type==messageType.text?'text':'image',



};



}


factory OurGroupChat.fromMap(Map<String,dynamic>map){


return OurGroupChat(groupchatId: map['groupchatId'], Name:map['Name'], senderId: map['senderId'], receiverId: map['receiverId'], image:map['Image'], message: map['message'], time:(map['time'] as Timestamp).toDate(), type:map['type']=='text'?messageType.text:messageType.image);


}


}
enum messagetype{
  text,image
}
