import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/herlper_function.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

    
void main() async
{
  //initializing all of the widgets
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
    {
      // run the initialization for web
      await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: Constants.apiKey,
              appId: Constants.appId,
              messagingSenderId: Constants.messagingSenderId,
              projectId: Constants.ProjectId
          ));
    }
  else
    {
      // run the initialization for android
      await Firebase.initializeApp();
    }

  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() =>_MyApp();

}
class _MyApp extends State<MyApp>
{
  bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserLoggedInStatus();
  }


  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value != null)
        {
          setState(() {
            _isSignedIn = value;
          });
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Constants().primaryColor),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn?const HomePage():const LoginPage(),
    );
  }

}