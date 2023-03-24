import 'package:chat_app/auth/register_page.dart';
import 'package:chat_app/helper/herlper_function.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget
{
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();

}

class _LoginPage extends State<LoginPage>{
  AuthSerive authSerive = AuthSerive();
  final formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 100),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Groupie", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                const Text('Login now to see what they are talking!', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                Image.asset('assets/images/login.png'),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val)
                  {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,),

                  ),
                  validator: (val){
                    if(val!.length < 6){
                      return "Password must be at least 6 characters";
                    }
                    else{
                      return null;
                    }
                  },
                  onChanged: (val)
                  {
                    setState(() {
                      password = val;
                    });
                  },

                ),
                const SizedBox(height: 20,),
                SizedBox(

                  width: double.infinity,
                    child: ElevatedButton(
                        onPressed: ()=>login(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        child: const Text('Sign In',style: TextStyle(fontSize: 16),)
                    )
                ),
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register here",
                          style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = (){
                            nextScreen(context, const RegisterPage());
                      }),

                    ]
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  login() async{
    if(formkey.currentState!.validate())
    {
      setState(() {
        _isLoading = true;
      });
      await authSerive.loginWithEmailandPassword(email, password).then((value) async{
        if(value == true)
        {
          //saving the shared preference state
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserNameSf(snapshot.docs[0]['fullName']);
          await HelperFunctions.saveUserEmailSf(email);
          nextScreenReplace(context, const HomePage());
        }

        else
        {
          showSnackbar(context, Colors.red , value);

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}