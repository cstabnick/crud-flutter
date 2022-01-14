import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './user_edit.dart';
import '../model/user.dart';
import '../util.dart';

// import './components/NavBar.dart';
class DisplayUsers extends StatefulWidget {
  const DisplayUsers({Key? key}) : super(key: key);
  @override
  _DisplayUsersState createState() => _DisplayUsersState();
}

class _DisplayUsersState extends State<DisplayUsers> {
  List<User> users = [];
  Future<List<User>>? fut;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  Future<List<User>> getAll() async {
    var response = await http.get(Uri.parse(Util.getUrl() + "/users"));

    if (response.statusCode == 200) {
      users.clear();
    }
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      users.add(User(u["user_id"], u["username"], u["email"], "u[]", -1));
    }
    return users;
  }

  Future deleteUser(int userId) async {
    await http.delete(Uri.parse(
      Util.getUrl() + "/users/${userId}",
    ));
  }

  Widget buildUserCard(User user) {
    return Card(
      child: ExpansionTile(
        onExpansionChanged: (isExpand) {
          if (!isExpand) {
            setState(() {});
          }
        },
        title: Text(
          user.email,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        subtitle: const Text("email"),
        children: <Widget>[
          ListTile(
            title: Text(
              user.sessionId.toString(),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text("session id"),
          ),
          Row(children: [
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[UserEdit(user)]),
                          ),
                        );
                      });
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => UserEdit(user)));
                },
                child: TextButton(
                    child: Text('Edit'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[UserEdit(user)]),
                            ),
                          );
                        },
                      );
                    })),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    fut = getAll();
    return Scaffold(
        body: FutureBuilder(
            future: fut,
            builder: (context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) => InkWell(
                        child: buildUserCard(snapshot.data![index]),
                        onLongPress: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          UserEdit(snapshot.data![index])
                                        ]),
                                  ),
                                );
                              });
                          setState(() {});
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => UserEdit(user)));
                        },
                        // ListTile(
                        //   title: Text(snapshot.data![index].username),
                        //   subtitle: Text(snapshot.data![index].email),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (_) => MyDetails(snapshot.data![index]))).then(onGoBack);
                        //   },
                        // ),
                      ));
            }));
  }
}
