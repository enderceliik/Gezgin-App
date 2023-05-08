
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:yuruyus_app/resources/resource.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final Resource _authMethods = Resource();

  User get getUser => _user!;
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();

  }

}