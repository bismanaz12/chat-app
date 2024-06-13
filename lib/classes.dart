

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CusDialog extends StatelessWidget {
  const CusDialog ({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,width: 160,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(children: [
         const Padding(
           padding: EdgeInsets.only(top:15.0,left: 10,right: 10),
           child: Row(children: [
             Text('You are Signup in our',style: TextStyle(color: Colors.black),),
           
            Text('ChatApp ',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
            Icon(Icons.thumb_up_alt_outlined,color: Colors.teal,)
                   
           ],),
         ),

         const Padding(
           padding: EdgeInsets.only(top:10.0,left: 10,right: 10),
           child: Row(children: [  Text('You need to Login in our'),
            Text('ChatApp .',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
          
           ],),
         ),
           const Padding(
             padding: EdgeInsets.only(right:10.0),
             child: Text('Go below of this page and try to Login'),
           ),
         const SizedBox(height: 10,),
Padding(
  padding: const EdgeInsets.only(left:150.0),
  child: ElevatedButton(onPressed: (){
  
    Navigator.pop(context);
  }, 
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    fixedSize:const Size(120, 10),
  ),
  child:const Text('OK',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
),
)


        ]),
        
      ),
    );
  }
}
// model

class Model{
  String uid1;
  String imageurl;
  String email;
  String name;
  String password;

  Model({required this.uid1,required this.email,required this.name,required this.password,required this.imageurl}); 
    

Map<String,dynamic> toMap(){
  return 
  {
  'uid':uid1,
  'email':email,
  'name':name,
  'password':password,
  'Imageurl':imageurl,
  };
}
 factory Model.fromMap(Map<String,dynamic>map){
  return Model(uid1: map['uid'], email: map['email'], name: map['name'], password: map['password'], imageurl: map['Imageurl']);
 }

}










class UserContainer extends StatelessWidget {
   UserContainer(this.img,this.txt1,{super.key});
    String  img;
    String txt1;
    

   

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:10,top: 15,),
      child: Container(
        color:Colors.transparent,
        height: 80,
        width:300,
        child: Row(children: [
          CircleAvatar(radius:30 ,backgroundImage:NetworkImage(img)),
        
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(txt1,style: const TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'MyFont'),),
            ),
            
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 80),
            //     child: Text('2 mint ago',style: TextStyle(color: Colors.grey,fontFamily: 'Main'),),
            //   )),
           
         
         
      
      
        ]),
      ),
    );
  }
}



class UserProvider with ChangeNotifier{
  Model? user;

  getuserdata() async{
    // DocumentSnapshot<Map<String ,dynamic>> snapshot =
     await  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
       user = Model.fromMap(value.data()!);
    notifyListeners();
    });

    
   

  }
  setUserNull(Model? user1){
      user=user1;
      notifyListeners();
    }

}