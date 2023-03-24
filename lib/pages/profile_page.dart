import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget
{
  String userName = "";
  String email = "";
  ProfilePage({Key? key,required this.email,required this.userName}):super(key: key);

  @override
  State<ProfilePage> createState() =>_ProfilePage();

}

class _ProfilePage extends State<ProfilePage>{

  AuthSerive authSerive = AuthSerive();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white, fontSize: 27,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(Icons.account_circle,size: 150,color: Colors.grey,),
            const SizedBox(height: 15,),
            Text(widget.userName,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            const SizedBox(height: 30,),
            const Divider(height: 2),
            ListTile(
              onTap: (){
                nextScreenReplace(context, const HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,

              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text('Groups',style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){

              },
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile',style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: ()async{
                showDialog(context: context,barrierDismissible: false, builder: (context){
                  return AlertDialog(
                    content: const Text('Are You Sure You Want To Logout?'),
                    title: const Text('Logout'),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.cancel,color: Colors.red,)),
                      IconButton(onPressed: ()async{
                        await authSerive.signout();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                      }, icon: const Icon(Icons.done,color: Colors.green,)),
                    ],
                  );
                });

              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle,size: 200, color: Colors.grey,),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17),),
                Text(widget.userName, style: TextStyle(fontSize: 17),),
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17),),
                Text(widget.email, style: TextStyle(fontSize: 17),),
              ],
            ),


          ],
        ),
      ),
    );
  }
}