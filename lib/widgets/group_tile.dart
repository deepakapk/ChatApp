
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget{
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({Key? key,required this.userName,required this.groupName, required this.groupId}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTile();

}

class _GroupTile extends State<GroupTile>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,));
      },
      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        margin: const EdgeInsets.only(top: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
          ),
          title: Text(widget.groupName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}", style: const TextStyle(fontSize: 13),),

        ),


      ),
    );
  }

}