


import 'package:app/classes.dart';
import 'package:app/creategroup.dart';
import 'package:app/memberprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
class GroupModel{
String groupId;
String groupName;
String groupImage;
String adminId;
List  Members;
 List MembersName;

GroupModel({required this.groupId,required this.groupName,required this.groupImage,required this.adminId,required this.Members,required this.MembersName});



Map<String,dynamic>toMap(){
  return {
    'groupId':groupId,
    'groupName':groupName,
    'groupImage':groupImage,
    'adminId':adminId,
    'members':Members,
    'membersName':MembersName,
  };

}

factory GroupModel.fromMap(Map<String,dynamic>map){

return GroupModel(groupId: map['groupId'], groupName:map['groupName'], groupImage: map['groupImage'], adminId:map['adminId'], Members:map['members'],MembersName: map['membersName']);

}





}







class AddMembers extends StatefulWidget {
   const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {

// List<String> members = [FirebaseAuth.instance.currentUser!.uid];
// List <String> membersName = [];

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<MemberProvider>(context,);
    var currentUser=Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
     const   SizedBox(height: 40,),
        Padding(
          padding: const EdgeInsets.only(right:340.0),
          child: InkWell(
            onTap: (){
          Navigator.pop(context);

            },
            child: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 30,)),
        ),
        //  Text('${membersName}',style: TextStyle(color: Colors.black),),
      
      SizedBox(
          height: 50,
           child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.selectedUserNames.length,

            itemBuilder: (context,index){
          
              return Container(
               child: Row(children: [
                  Text(provider.selectedUserNames[index]!=currentUser!.name && provider.selectedUserIds[index]!=currentUser.uid1?provider.selectedUserNames[index]:'',style: const TextStyle(color: Colors.black,fontFamily: 'Simple',fontSize: 20),),
            if(provider.selectedUserNames[index]!=currentUser.name && provider.selectedUserIds[index]!=currentUser.uid1)      IconButton(onPressed: (){
                
                   provider.removeSelectedUserIdsandNames(provider.selectedUserIds[index], provider.selectedUserNames[index]);
                      
         
                     
                  }, 
                   
                  icon: const Icon(Icons.cancel,color: Color.fromRGBO(0, 0, 0, 1),))
                ],)
              );
           
           }
           
           ),
         ),

       
        
  
         Expanded(
           child: StreamBuilder(stream: FirebaseFirestore.instance.collection('users').where('uid',isNotEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
                 builder: (context, snapshot) {
                 if(snapshot.hasData){
                  return ListView.builder(
                   itemCount: snapshot.data!.docs.length,
                   shrinkWrap: true,
                   itemBuilder: (context,index){
                     var data = snapshot.data!.docs[index].data();
                     Model user=Model.fromMap(data);
                     return InkWell(
                       onTap: (){
                       if(!provider.selectedUserIds.contains(currentUser!.uid1) && !provider.selectedUserNames.contains(currentUser.name)){
                        provider.addSelectedUserIdsandNames(currentUser.uid1, currentUser.name);
                       }
                     if( ! provider.selectedUserNames.contains(user.name) && !provider.selectedUserIds.contains(user.uid1)){
                      provider.addSelectedUserIdsandNames(user.uid1, user.name);
                      
                     }
                        print('selected user ids,${provider.selectedUserIds} ${provider.selectedUserNames}');
                         
                       },
                       child: UserContainer(data['Imageurl'], data['name']));
                             
                  });
                }
                else{
                 return const Center(child: SpinKitDoubleBounce(color:Color.fromARGB(255, 3, 27, 47),size: 40,),);
                }
               
                
                
                               
                 },
                ),
         ),
               
         ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                fixedSize: const Size(420, 50),
                shape: const RoundedRectangleBorder()
              ),
              onPressed: (){
             showDialog(context: context, builder: (context)=>CreateGroup(members: provider.selectedUserIds,membersName: provider.selectedUserNames,));
            }, child:const Text('Add Members',style: TextStyle(color: Colors.white,fontFamily: 'Main',fontSize: 25),))

       
      
        
      ]),
      
    );
  }
}