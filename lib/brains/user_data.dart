import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:visits_prod/brains/data_layer/firebase_repo.dart';

class UserData extends ChangeNotifier {
  MyUser? user;

  bool get auth => user != null;

  UserData() {
    loginSilent();
  }

  Future<void> login(String email, String pass) async {
    setUser(MyUser.userFromFirebase(await FirebaseRepo.loginUser(email, pass)));
  }

  Future<void> register(String email, String pass) async {
    setUser(
        MyUser.userFromFirebase(await FirebaseRepo.registerUser(email, pass)));
  }

  Future<void> loginSilent() async {
    var result = FirebaseRepo.getUser();
    if (result != null) {
      setUser(MyUser.userFromFirebaseUser(result));
    }
  }

  void setUser(MyUser user) {
    this.user = user;
    print(this.user);
    print(user.userCredential.email);
    notifyListeners();
  }
}

class MyUser {
  final User userCredential;
  MyUser({
    required this.userCredential,
  });

  factory MyUser.userFromFirebase(UserCredential credential) {
    return MyUser(userCredential: credential.user!);
  }
  factory MyUser.userFromFirebaseUser(User user) {
    return MyUser(userCredential: user);
  }
}
