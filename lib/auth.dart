import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:skate_maps/database.dart';
import 'package:skate_maps/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getUser() async {
    var user = await _auth.currentUser();
    return _userFromFirebase(user);
  }

  // create user from firebase user
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid:user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }


  // sign in /w email and pass
  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register w/ email and pass
  Future registerWithEmail(String email, String password, String fname, String lname) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await  DatabaseService(uid: user.uid).setUserData(fname, lname,user.email,0);
      return _userFromFirebase(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
}