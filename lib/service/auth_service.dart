import 'package:chat_app/helper/herlper_function.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthSerive {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user != null)
        {
          return true;
        }
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }




  //register
  Future registerUserWithEmailandPassword(String fullName, String email, String password) async{
    try{
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if(user != null){
        await DatabaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  //Logout
  Future signout() async{
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSf("");
      await HelperFunctions.saveUserNameSf("");
      await firebaseAuth.signOut();
    }catch (e){
      return null;
    }
  }
}