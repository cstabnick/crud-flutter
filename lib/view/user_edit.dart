import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../util.dart';

class UserEdit extends StatefulWidget {
  final User user;
  const UserEdit(this.user);

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  Future deleteUser(int user_id) async {
    await http.delete(Uri.parse(
      Util.getUrl() + "/users/${user_id}",
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        children: [
          
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.user.id}'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.user.username),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.user.email),
                ],
              ),
            ),
            // height: 455 ,
            width: MediaQuery.of(context).size.width,
            decoration:
                const BoxDecoration(color: Color(0xffFFFFFF), boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 1),
              ),
            ]),
          ),
          Row(children: [
            TextButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (_)=>EditUser(users: widget.users,)));
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                deleteUser(widget.user.id);
              },
              child: Text('Delete'),
            ),
          ])
        ],
      ),
    );
  }
}
