import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './home.dart';
import '../model/user.dart';
import '../util.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);
  

  @override
  _CreateUserState createState() => _CreateUserState();
}

String email = "";
String password = "";
String username = "";


class _CreateUserState extends State<CreateUser> {
  TextEditingController nameController =
      TextEditingController(text: username);
  TextEditingController emailController =
      TextEditingController(text: email);
  TextEditingController passwordController =
      TextEditingController(text: password);

  String errorMessage = "";

  void save() async {
    var newUser = await http.post(Uri.parse(Util.getUrl() + "/users/create"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8',
        },
        body: json.encode({
          "username": username,
          "email": email,
          "password": password
        }));


    if (newUser.statusCode == 200) {
      var decodedData = jsonDecode(newUser.body);

      User user = User(decodedData["user_id"], decodedData["username"], decodedData["email"], '', decodedData['current_session_id']);
      
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Home(user)));
      errorMessage = "";
    }
    else {
      switch (newUser.statusCode) {
        case 409: {
            errorMessage = "User already exists";
        } break;
        default: {
            errorMessage = "Rip brub please try again";
        } break;
      }

    }
    
    setState(() {}); // force refresh?
  }

  @override
  Widget build(BuildContext context) {
    //  print(widget.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        elevation: 0.0,
        title: Text('Create User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100, bottom: 100, left: 18, right: 18),
          child: Container(
            height: 550,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.indigo[700],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 300,
                    child: Text(errorMessage,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 50, 50),
                        ))),
                Container(
                    width: 300,
                    decoration: BoxDecoration(boxShadow: []),
                    child: TextField(
                      controller: nameController,
                      onChanged: (val) {
                        username = val;
                      },
                      decoration: InputDecoration(hintText: "username"),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: 300,
                    decoration: BoxDecoration(boxShadow: []),
                    child: TextField(
                      controller: emailController,
                      onChanged: (val) {
                        email = val;
                      },
                      decoration: InputDecoration(hintText: "email"),
                    )),
                Container(
                    width: 300,
                    decoration: BoxDecoration(boxShadow: []),
                    child: TextField(
                      //hintText: 'Password',
                      onChanged: (val) {
                        password = val;
                      },
                      controller: passwordController,
                      obscureText: true,
                      //style: TextStyle(),
                      decoration: InputDecoration(hintText: "password"),
                    )),
                SizedBox(
                  width: 100,
                  child: TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: save,
                      child: Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
