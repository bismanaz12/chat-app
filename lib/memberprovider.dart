import 'package:flutter/material.dart';

class MemberProvider with ChangeNotifier{
  List<String> selectedUserIds=[];
  List<String> selectedUserNames=[];


  addSelectedUserIdsandNames(String id,String name){
    selectedUserIds.add(id);
    selectedUserNames.add(name);
    notifyListeners();
  }
  removeSelectedUserIdsandNames(String id,String name){
    selectedUserIds.remove(id);
    selectedUserNames.remove(name);
    notifyListeners();
  }
}