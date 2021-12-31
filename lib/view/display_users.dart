import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './my_details.dart';
import '../model/user.dart';
import '../util.dart';

class DisplayUsers extends StatefulWidget {
  const DisplayUsers({Key? key}) : super(key: key);
  @override
  _DisplayUsersState createState() => _DisplayUsersState();
}

class _DisplayUsersState extends State<DisplayUsers> {
  List<User> users = [];
  Future<List<User>>? fut;

  Future<List<User>> getAll() async {
    var response = await http.get(Uri.parse(Util.getUrl() + "/users"));

    if (response.statusCode == 200) {
      users.clear();
    }
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      users.add(User(u["user_id"], u["username"], u["email"], u["password"]));
    }
    return users;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      fut = getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    fut = getAll();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Display Users'),
          elevation: 5.0,
          backgroundColor: Colors.indigo[700],
        ),
        body: FutureBuilder(
            future: fut,
            builder: (context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) => InkWell(
                        child: ListTile(
                          title: Text(snapshot.data![index].username),
                          subtitle: Text(snapshot.data![index].email),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MyDetails(
                                          user: snapshot.data![index],
                                        ))).then(onGoBack);
                          },
                        ),
                      ));
            }));
  }
}
