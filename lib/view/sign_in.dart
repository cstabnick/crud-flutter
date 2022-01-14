import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './display_users.dart';
import './home.dart';
import './add_user.dart';
import '../model/user.dart';
import '../util.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}


String email = "";
String password = "";

class _SignInState extends State<SignIn> {
  

  TextEditingController emailController =
      TextEditingController(text: email);
  TextEditingController passwordController =
      TextEditingController(text: password);

  String errorMessage = "";

  void login() async {
    var loginRes = await http.post(
        Uri.parse(
          Util.getUrl() + "/users/login", // android
          //"http://127.0.0.1:8000/users/login", // ios
        ),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8',
        },
        body: json.encode({"email": email, "password": password}));

    if (loginRes.statusCode == 401) {
      errorMessage = "Bad job dude!";
      setState(() {});
    } 
    
    if (loginRes.statusCode == 200) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (_) => Home()));
      // User u = User();
      var decodedData = jsonDecode(loginRes.body);

      User user = User(decodedData["user_id"], decodedData["username"], decodedData["email"], '', decodedData["current_session_id"]);
      
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Home(user)),
          (Route<dynamic> route) => false);
    }
  }

  void newUser() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => CreateUser()),
        (Route<dynamic> route) => false); 
  }

  @override
  Widget build(BuildContext context) {
    //  print(widget.id);
    return Scaffold(
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
                Container(
                  width: 300,
                  child: Row(children: [
                    SizedBox(
                      width: 40,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: newUser,
                        child: Text('New User')),
                    SizedBox(
                      width: 40,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: login,
                        child: Text('Login')),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
