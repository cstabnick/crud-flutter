import 'dart:async';
import 'dart:convert';
import 'package:crud/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './my_details.dart';
import '../model/user.dart';
import '../util.dart';
import './display_users.dart';
import './sign_in.dart';

class Home extends StatefulWidget {
  final User? user;
  const Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget? bodyWidget;
  String appBarTitle = "Home";

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        drawer: Drawer(
          child: ListView(
            children: [ 
              ListTile(title: widget.user == null ? Text("") : Text(widget.user!.sessionId.toString())),
              ListTile(
                  title: const Text("Users"),
                  onTap: () {
                    setState(() {
                      // ignoring because I want a click to always reload the users
                      // ignore: prefer_const_constructors 
                      bodyWidget = DisplayUsers(); 
                      appBarTitle = "Users";
                    });

                    Navigator.pop(context);
                  }),
                ListTile(
                  title: const Text("My Details"),
                  onTap: () {
                    setState(() {
                      // ignoring because I want a click to always reload the users
                      // ignore: prefer_const_constructors 
                      bodyWidget = MyDetails(widget.user); 
                      appBarTitle = "My Details";
                    });

                    Navigator.pop(context);
                  })
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(appBarTitle),
          elevation: 5.0,
          backgroundColor: Colors.indigo[700],
        ),
        body: bodyWidget);
  }
}
