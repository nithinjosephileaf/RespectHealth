import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class GlobalVarService extends ChangeNotifier{

  static final GlobalVarService _instance = GlobalVarService._internal();
    RemoteMessage? _lastMessage;

  //short getter for my variable
  RemoteMessage? get lastMessage => _lastMessage;

  //short setter for my variable
  set lastMessage(RemoteMessage? message)  {
    _lastMessage = message;
    notifyListeners();
  }

  // passes the instantiation to the _instance object
  factory GlobalVarService() => _instance;
   GlobalVarService._internal() {
    _lastMessage = null;
    notifyListeners();
  }
}