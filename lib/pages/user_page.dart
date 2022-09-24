import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:user_hive/databases/user_class.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Box<User> usersBox = Hive.box<User>('user');
  List<User>? usersList;
  ValueNotifier<List<User>>? usersListNotifier;
  // late User user;
  @override
  void initState() {
    super.initState();
    usersList = usersBox.values.toList();
    usersListNotifier = ValueNotifier(usersList!);

    debugPrint('#########################################');
    debugPrint(usersList.toString());
    debugPrint('#########################################');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addUser');
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Users List'),
        ),
        body: (usersList!.isEmpty)
            ? const Center(
                child: Text(
                  'Users\' List is empty    :(',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ValueListenableBuilder(
                valueListenable: usersBox.listenable(),
                builder: (BuildContext context, value, Widget? child) =>
                    ValueListenableBuilder(
                  valueListenable: usersListNotifier!,
                  builder: (BuildContext context, List<User> usersList,
                          Widget? child) =>
                      ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: deleteData(),
                                  backgroundColor:
                                      const Color.fromARGB(255, 199, 172, 172),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(usersList[index].name!),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(usersList[index].age!.toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(usersList[index].city!),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        print('@@@@@@@@@@@@@@@@@@@@@@@@');
                                        print(usersList[index]);
                                        Navigator.pushNamed(
                                          context,
                                          '/updateUser',
                                          arguments: [
                                            usersList[index],
                                          ],
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  deleteData() {}
  updateData(
    User user,
    String name,
    int age,
    String city,
  ) {
    user.name = name;
    user.age = age;
    user.city = city;
    user.save();
  }
}
