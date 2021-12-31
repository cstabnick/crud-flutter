import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../util.dart';

class MyDetails extends StatefulWidget {
  final User? user;
  const MyDetails({this.user});

  @override
  _MyDetailsState createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  Future deleteUser(int user_id) async {
    await http.delete(Uri.parse(
      Util.getUrl() + "/users/${user_id}",
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Details'),
        elevation: 0.0,
        backgroundColor: Colors.indigo[700],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.indigo[700],
                child: Center(
                    child: Text(
                  'Details',
                  style: TextStyle(color: Color(0xffFFFFFF)),
                )),
              ),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.user!.id}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(widget.user!.username),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(widget.user!.email),
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
                    deleteUser(widget.user!.id);
                  },
                  child: Text('Delete'),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
