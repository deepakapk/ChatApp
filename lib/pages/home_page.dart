
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/herlper_function.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget
{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() =>_HomePage ();

}

class _HomePage extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthSerive authSerive = AuthSerive();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }


  // string manipulatoin to get group name and group id
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }
  
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async{
    await HelperFunctions.getUserNameFromSf().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUserEmailFromSf().then((value)  {
      setState(() {
        email = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Groups', style: TextStyle(color: Colors.white,fontSize: 27, fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))

        ],
      ),
     drawer: Drawer(
       child: ListView(
         padding: const EdgeInsets.symmetric(vertical: 50),
         children: [
           const Icon(Icons.account_circle,size: 150,color: Colors.grey,),
           const SizedBox(height: 15,),
           Text(userName,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
           const SizedBox(height: 30,),
           const Divider(height: 2),
           ListTile(
             onTap: (){},
             selectedColor: Theme.of(context).primaryColor,
             selected: true,
             contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
             leading: const Icon(Icons.group),
             title: const Text('Groups',style: TextStyle(color: Colors.black),),
           ),
           ListTile(
             onTap: (){
               nextScreenReplace(context,  ProfilePage(userName: userName,email: email,));
             },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDailog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        child:const Icon(Icons.add,color: Colors.white,size: 30,),

      ),
    );
  }



  popUpDailog(BuildContext context){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Create a group", textAlign: TextAlign.left,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading==true?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),)
                    :TextField(
                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                      focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor
                  ),
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                  onPressed: ()async{
                    if(groupName != "")
                      {
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName,FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete((){
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackbar(context, Colors.green, "Group created Successfully.");
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor
                  ),
                child: const Text("CREATE"),
              ),
            ],
          );
        });
  }





  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null)
          {
            if(snapshot.data['groups'].length != 0)
            {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index){
                  int reverseIndex = snapshot.data["groups"].length - index -1;
                  return GroupTile(

                      userName: snapshot.data["fullName"],
                      groupName: getName(snapshot.data["groups"][reverseIndex]),
                      groupId: getId(snapshot.data["groups"][reverseIndex])
                  );
                },

              );

            }
            else
            {
              return noGroupWidget();
            }

          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return  Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }


  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: (){popUpDailog(context);},
              child: Icon(Icons.add_circle, color: Colors.grey[700],size: 75,)
          ),
          const SizedBox(height: 20,),
          const Text("You've not joined any groups, tap on the add icon to create a group or also search from top search button.",textAlign: TextAlign.center,)
        ],
      ),
    );
  }


}










