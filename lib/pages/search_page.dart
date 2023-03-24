import 'package:chat_app/helper/herlper_function.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget
{
  const SearchPage({Key? key}): super(key: key);

  @override
  State<SearchPage> createState() => _SearchPage();

}

class _SearchPage extends State<SearchPage>{
  String userName = "";
  User? user;
  bool isLoading = false;
  bool isJoined = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }
  getCurrentUserIdandName()async{
    await HelperFunctions.getUserNameFromSf().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }
  String getId(String r){
    return r.substring(0,r.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search",style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration:  const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups...",
                        hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                      ),

                    )
                ),
                GestureDetector(
                  onTap: (){initiateSearchMethod();},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.search,color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
          isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if(searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchGroupByName(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }


  groupList(){
    return hasUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context, index){
        return groupTilee(userName,searchSnapshot!.docs[index]['groupId'],searchSnapshot!.docs[index]['groupName'],searchSnapshot!.docs[index]['admin']);
      },
    ) : Container();
  }

  joinedOrNot(String userName, String groupId, String groupName, String admin) async
  {
      await DatabaseService(uid: user!.uid).isUserJoined(groupName,  groupId, userName).then((value) {
        setState(() {
          isJoined = value;
        });
      });
  }


  Widget groupTilee(String userName, String groupId, String groupName, String admin){
    //function to check whether user already exisits in group
    joinedOrNot(userName,groupId,groupName,admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(groupName.substring(0,1).toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 20),),
      ),
      title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
            await DatabaseService(uid: user!.uid).toglleGroupJoin(groupId, userName, groupName);
            if(isJoined) {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackbar(context, Colors.green, "Successfully joined the group");
              Future.delayed(const Duration(seconds: 2));
              nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            } else {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackbar(context, Colors.red, "Succefully Left the group $groupName");
            }
        },
        child: isJoined ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical:10 ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Text("JOINED", style: TextStyle(color: Colors.white),),
        ) : Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
          ),
          child: const Text('JOIN',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}