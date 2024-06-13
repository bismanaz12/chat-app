import 'dart:io';

import 'package:app/groupmodel.dart';
import 'package:app/groups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
   CreateGroup({super.key,required this.members,required this.membersName});
List <String> members;
 List <String>membersName;

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
TextEditingController groupname = TextEditingController();

File? image;

Future<String>downloadurl(File file)async{
String id = const Uuid().v4();
String url='';
FirebaseStorage firestor = FirebaseStorage.instance;
await firestor.ref().child('groups').child('$id.png').putFile(file).then((p0)async{
  url = await  p0.ref.getDownloadURL();
});
return url;
}

  @override
  Widget build(BuildContext context) {
  
    return Dialog(
      child: Container(
        height: 266,width: 230,
        decoration: const BoxDecoration(color: Colors.white,),
        child: Column(children: [
          const SizedBox(height: 30,),
          InkWell(
            onTap: ()async{
              ImagePicker picker = ImagePicker();
              XFile? pickedimage = await picker.pickImage(source:ImageSource.camera);
              if(pickedimage != null){
                image = File(pickedimage.path);
                
              setState(() {
                
              });
              }
              
              
        
            },
             child: image == null?const Row(
               children: [
                SizedBox(width: 10,),
                 CircleAvatar(radius: 30,backgroundColor: Colors.teal,),
                 SizedBox(width: 8,),
                 Text('Select Image',style: TextStyle(color: Colors.teal,fontSize: 20,fontFamily: 'Main'),)
               ],
             ):Row(
               children: [
                const SizedBox(width: 10,),
                 CircleAvatar(radius: 30,backgroundImage: FileImage(image!),),
                  const Text('Your Profile',style: TextStyle(color: Colors.teal,fontSize: 20,fontFamily: 'Main'),)
               ],
             )
           ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20),
            child: TextFormField(
              style: const TextStyle(color: Colors.black,fontSize: 20),
              controller: groupname,
              decoration: const InputDecoration(
              
                label: Text('Group Name',style: TextStyle(color: Colors.teal,fontFamily: 'Simple',fontSize: 20),),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 2)),
                focusedBorder:   UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 2))
              ),
            ),
          ),
          const SizedBox(height: 38,),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: const Size(180, 38),
                  shape: const RoundedRectangleBorder(
                       side: BorderSide(color: Colors.teal)
                  )
                ),
                onPressed: ()async{
                  
                  try{
                    if(groupname.text.isNotEmpty && image != null){
                   
                    String url = await downloadurl(image!);
                  String groupId = const Uuid().v4();
                  GroupModel group = GroupModel(groupId: groupId, groupName: groupname.text, groupImage: url, adminId: FirebaseAuth.instance.currentUser!.uid, Members:widget.members,MembersName: widget.membersName );
                FirebaseFirestore.instance.collection('groups').doc(groupId).set(group.toMap());
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyGroups()));
                // Navigator.pop(context);
                  }
                  }
                  catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                      
                }, child:const Text('Create Group',style: TextStyle(color: Colors.teal,fontFamily: 'Main',fontSize: 20),)),
             ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(98, 38),
              shape: const RoundedRectangleBorder(
                   side: BorderSide(color: Colors.teal)
              )
            ),
            onPressed: (){
              Navigator.pop(context);
             
        
            }, child:const Text('Exit',style: TextStyle(color: Colors.teal,fontFamily: 'Main',fontSize: 20),))
            ],
          )
        
        ]),
      ),

    );
  }
}