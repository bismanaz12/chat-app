
import 'package:app/chatscreen.dart';
import 'package:app/classes.dart';
import 'package:app/first.dart';
import 'package:app/groupmodel.dart';
import 'package:app/groups.dart';
import 'package:app/my.dart';
import 'package:app/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
   String search ='';
  TextEditingController serachController = TextEditingController();
@override
  void initState() {
  
    super.initState();
 
     getdata();
  }
  getdata() {
     if(FirebaseAuth.instance.currentUser !=null){
       Provider.of<UserProvider>(context,listen: false).getuserdata();
     }
   }

  @override
  
  Widget build(BuildContext context) {
    TextEditingController title= TextEditingController();
    
   var provider=     Provider.of<UserProvider>(context,);
   
  //  provider.getuserdata();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body:
      provider.user==null ?const Center(child: CircularProgressIndicator(),) :
     CustomScrollView(slivers: [
      SliverFillRemaining(hasScrollBody: true,child: Column(children: [
       const SizedBox(height: 50,),
           
     
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Row(
             
             children: [
             
                       CircleAvatar(
                        backgroundColor:Colors.black,
                         child: Icon(
                          Icons.search,color:Colors.white,size:30
                         ),
                       ),
                         Container(
                          
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.all(
                          //     Radius.circular(20)
                          //   ),
                          //   color: Colors.grey,
                          // ),
                            height:30,width:120,
                          child:  TextFormField(
                            style: TextStyle(color: Colors.white,fontSize: 20),
                            decoration:InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                               borderSide:
                                BorderSide(color:Colors.white, width: 2),
                                
                                
                              ),
                               focusedBorder: UnderlineInputBorder(
                               borderSide:
                                BorderSide(color:Colors.white, width: 2),
                                
                                
                              )
                            ),
     
                            controller: serachController,
                            
                            onChanged: (String value){
                                       setState(() {
                                         search = value;
                                       });
                         
                         
                                      },
                                      
                                      ),
                          ),
                       
                    
            //  ElevatedButton(
            //    style: ElevatedButton.styleFrom(
                 
            //     //  shape: const CircleBorder(
            //     //    side: BorderSide(color: Colors.grey,width: 0.5)
            //     //  ),
            //      backgroundColor: Colors.black,
                        
            //    ),
            //    onPressed: (){
            //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyScreen()));
            //     //  showDialog(context:context, builder: (context){
                //      // return 
                //      return Dialog(
                    //  child: Row(
                    //    children: [
                    //      Container(
                    //         height:50,width:120,
                    //       child:  TextFormField(
                    //         controller: serachController,
                            
                    //         onChanged: (String value){
                    //                    setState(() {
                    //                      search = value;
                    //                    });
                         
                         
                    //                   },
                                      
                    //                   ),
                    //       ),
                    //    ],
                    //  );
                  
              //  }, child:const Icon(Icons.search,color:Colors.white ,size: 30,)),
              
               
               const Text('Home',style: TextStyle(color: Colors.white,fontSize: 25),),
               const SizedBox(width: 120,),
               
                 InkWell(
                   onTap: (){
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                    Get.to(()=>const Profile(),transition: Transition.upToDown,duration: const Duration(seconds: 2));
                   },
                   child: CircleAvatar(backgroundImage: NetworkImage(Provider.of<UserProvider>(context,listen: false).user!.imageurl),
                   ),
                 ),
                        ],),
          ),
          const SizedBox(height: 20,),
         StreamBuilder(stream: FirebaseFirestore.instance.collection('users').where('uid',isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(), 
         builder: (context,snapshot){
           if(snapshot.hasData){
             return SizedBox(
               height: 100,
                child: ListView.builder(
                   scrollDirection: Axis.horizontal,
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context,index){
     // String name = index.toString();
                  //  String  name = snapshot.data!.docs[index].data().toString();
                 var data1= snapshot.data!.docs[index].data();
                 
                 return Padding(
                   padding: const EdgeInsets.only(left: 10),
                   child: CircleAvatar(radius: 40,backgroundImage:NetworkImage('${data1['Imageurl']}'),),
                 );
                  
                 
                
                }),
              );
           }
            return SpinKitCircle(
              color: Color.fromARGB(255, 1, 12, 31),
              
            );
           
     
         }
      
         ),
         
          const SizedBox(height: 20,),
       
      
         Expanded(
           child: Container(
           
           
             decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(45),topRight: Radius.circular(45))),
             child: SingleChildScrollView(
               child: Column(
                 children: [
                  Padding(
                    padding: const EdgeInsets.only(left:340.0),
                    child: PopupMenuButton(
                    
                     
                     onSelected: (value){
                    {
                     
                    if(value == 'Add new Friend'){
                     showDialog(context:context, builder: (context){
                       // return 
                       return Dialog(
                         child: Container(
                           width: 200,height: 210,
                           decoration: const BoxDecoration(color: Colors.white),
                           child: Column(
                             children: [
                               const SizedBox(height: 20,),
                               const CircleAvatar(backgroundImage: AssetImage('assets/images/chat.png'),radius: 50,backgroundColor: Colors.lime,),
                             
                                   const SizedBox(height: 42,),
                                     Row(
                                       children: [
                                         ElevatedButton(
                                           style: ElevatedButton.styleFrom( 
                                             backgroundColor: Colors.white,
                                             shape: const RoundedRectangleBorder(
                                              side: BorderSide(color: Color.fromRGBO(3, 103, 134, 0.966))
                                             ),
                                           fixedSize: const Size(170, 40)
                                           ),
                                           onPressed: (){
                                            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>First()));
                                            Get.to(()=>const First(),transition: Transition.leftToRightWithFade,duration: const Duration(seconds: 3));
                                           },
                                           child:const Text('Add Friend',style: TextStyle(color: Color(0xF8036786),fontFamily: 'Main',fontSize: 18),) ),
                                       ElevatedButton(
                                       style: ElevatedButton.styleFrom(
                                         backgroundColor: Colors.white,
                                         shape: const RoundedRectangleBorder(
                                           side: BorderSide(color:Color.fromRGBO(3, 103, 134, 0.966) )
                                         ),
                                       fixedSize: const Size(110, 30)
                                       ),
                                       onPressed: (){
                                         Navigator.pop(context);
                                       },
                                       child:const Text('Exit',style: TextStyle(color: Color.fromRGBO(3, 103, 134, 0.966),fontFamily: 'Main',fontSize: 18),) ),
                                
                                       ],
                                     ),
                                
                                  
                               
                             ],
                           ),
                         ),
                       );
                     });
                     
                       
                        
                     }
                     else if(value == 'Create Group'){
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMembers()));
                      Get.to(()=>const AddMembers(),transition: Transition.fade,duration: const Duration(seconds: 2));
                           
                     }
                     else if(value == 'My Groups'){
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyGroups()));
                      Get.to(()=>const MyGroups(),transition: Transition.fade,duration: const Duration(seconds: 2));
                     }
                     
                     
                     
                    
                    }
                    
                    
                    },
                    itemBuilder: (context){
                     return [
                       const PopupMenuItem(value: 'Add new Friend',child: Text('Add new Friend',style: TextStyle(color: Colors.black),)),
                       const PopupMenuItem(value: 'Create Group',child: Text('Creat Group ',style: TextStyle(color: Colors.black))),
                       const PopupMenuItem(value: 'My Groups',child: Text('My Groups ',style: TextStyle(color: Colors.black))),
                           
                     ];
                    },
                    ),
                  ),
                  
                StreamBuilder(stream: FirebaseFirestore.instance.collection('users').where('uid',isNotEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
                 builder: (context, snapshot) {
                 if(snapshot.hasData){
                  return ListView.builder(
                   itemCount: snapshot.data!.docs.length,
                   shrinkWrap: true,
                   itemBuilder: (context,index){
                  
                  
                    
                     var data = snapshot.data!.docs[index].data();
                       String name1 =data['name']; 
                     
                     Model receiverUser=Model.fromMap(data);
                     if(serachController .text.isEmpty){ return InkWell(
                      onDoubleTap: (){
                        showDialog(context: context, builder: (contetx){
                          return Dialog(
                            child: Container(
                              height:230,
                              width: 150,
                              child: Column(children: [
                                Padding(
                                                    padding: const EdgeInsets.only(left:240),
                                                    child: InkWell(
                                                      onTap:(){
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(Icons.cancel_outlined,size:30,color:Colors.red)),
                                                  ),
                                        SizedBox(
                                          height:20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(receiverUser.imageurl),
                                              ),
                                              SizedBox(width:15),
                                              Text(receiverUser.name,style:TextStyle(color:Colors.black,fontSize: 25,fontFamily: 'MyFont')),
                                            ],
                                          ),
                                        ),

                                Padding(
                                  padding: const EdgeInsets.only(top:45),
                                  child: Row(
                                    children: [
                                      
                                      InkWell(
                                        onTap: (){
                                          FirebaseFirestore.instance.collection('users').doc(receiverUser.uid1).delete();
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:30),
                                          child: Container(
                                            height: 45,width: 100,
                                           
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_outline,color:Colors.black,size:30),
                                                Center(child: Text('Delete',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: 'Main'),)),
                                              ],
                                            )),
                                        )),
                                      
                                      InkWell(
                                        onTap: (){
                                           title.text=receiverUser.name;
                                         showDialog(context: context, builder: (context){
                                          return Dialog(
                                            child: Container(
                                              height: 180,
                                              width:150,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:240),
                                                    child: InkWell(
                                                      onTap:(){
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(Icons.cancel_outlined,size:30,color:Colors.red)),
                                                  ),
                                                  Container(
                                                    width:100,
                                                    
                                                    child: TextFormField(
                                                      style: TextStyle(color:Colors.black,fontSize:20),
                                                      decoration: InputDecoration(
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(width: 4,color: Colors.black)),
                                                           focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(width: 4,color: Colors.black))
                                                      ),
                                                     controller: title,
                                                    ),
                                                  ),
                                                  SizedBox(height: 45,),
                                                  InkWell(
                                                    onTap: (){
                                                     

                                                      FirebaseFirestore.instance.collection('users').doc(receiverUser.uid1).update(
                                                       {
                                                        'name':title.text,
                                                       }
                                                      );
                                                       Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height:40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                                      ),
                                                      child: Center(child: Text('Update',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Main'))))),
                                                ],

                                              ),
                                            ),
                                          );
                                         });
                                        },
                                        child:  Padding(
                                          padding: const EdgeInsets.only(right:20),
                                          child: Container(
                                            height: 45,width: 100,
                                            
                                            child: Row(
                                              children: [
                                                Icon(Icons.update_outlined,color:Colors.black,size:30),
                                                Center(child: Text('Update',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: 'Main'),)),
                                              ],
                                            )),
                                        )),
                                  
                                    ],
                                  ),
                                )
                              ],),

                            ),
                          );
                        });
                      },
                       onTap: (){
                         Navigator.of(context).push(MaterialPageRoute(builder:(context) => Chating(receiverUser1:receiverUser )));
                       },
                       child: UserContainer(data['Imageurl'], data['name']));
                             }
                             else if(name1.toLowerCase().contains(serachController.text.toLowerCase())){
                              return InkWell(
                       onTap: (){
                         Navigator.of(context).push(MaterialPageRoute(builder:(context) => Chating(receiverUser1:receiverUser )));
                       },
                       child: UserContainer(data['Imageurl'], name1));
                    
                             }
                             else{
                              Container();
                             }
                    
                    
                  });
                }
                else{
                 return const Center(child:
                 SpinKitThreeBounce(color:Color.fromARGB(255, 5, 55, 142)),
                 );
                }
               
                
                
                               
                 },
                ),
                 
                 ],
               ),
             ),
             ),
         ),
         
         
     
     
     ],)
       ,)
     ],)
    
    );
  }
}