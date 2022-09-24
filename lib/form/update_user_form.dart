import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:user_hive/databases/user_class.dart';

class UpdateUser extends StatefulWidget {
  User? user;
  UpdateUser(this.user, {Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    nameController.text = user!.name!;
    ageController.text = user!.age!.toString();
    cityController.text = user!.city!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: nameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: 'What do people call you?',
                              labelText: 'Name',
                            ),
                            onSaved: (String? value) {
                              if (value != null) {
                                nameController.text = value;
                              }
                            },
                            validator: (String? value) {
                              return (value != null && value.isEmpty)
                                  ? 'Do not use the name.'
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: ageController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: 'What is your age?',
                              labelText: 'Age',
                            ),
                            onSaved: (String? value) {
                              if (value != null) {
                                ageController.text = value;
                              }
                            },
                            validator: (String? value) {
                              return (value != null && value.isEmpty)
                                  ? 'Please enter the age.'
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: cityController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: 'Where do you live ?',
                              labelText: 'City',
                            ),
                            onSaved: (String? value) {
                              if (value != null) {
                                cityController.text = value;
                              }
                            },
                            validator: (String? value) {
                              return (value != null && value.isEmpty)
                                  ? 'Enter your city name.'
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                    right: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      submitUserDetails();
                    },
                    child: const Text('SAVE'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool submitUserDetails() {
    final userForm = formKey.currentState;
    if (userForm != null) {
      if (userForm.validate()) {
        userForm.save();
        debugPrint('User form is being saved.');
        sureConsent();
        return true;
      }
    }
    debugPrint('User form is null.');
    return false;
  }

  sureConsent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('UPDATE USER'),
          content: const Text(
            'Are you sure to update this user?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                updateUsersHive(
                  nameController.text,
                  int.parse(ageController.text),
                  cityController.text,
                );
                SnackBar snackBar = const SnackBar(
                  content: Text('User has been updated successfully !'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future updateUsersHive(String name, int age, String city) async {
    user!.name = name;
    user!.age = age;
    user!.city = city;
    debugPrint(user!.name.toString());
    user!.save();
    Navigator.pop(context);
  }
}
