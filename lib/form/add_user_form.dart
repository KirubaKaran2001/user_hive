import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:user_hive/databases/user_class.dart';

class AddUserForm extends StatefulWidget {
  const AddUserForm({Key? key}) : super(key: key);

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  Box<User> usersBox = Hive.box<User>('user');

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
          title: const Text('ADD USER'),
          content: const Text(
            'A new user will be added. Are you sure ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                saveToUsersHive(
                  nameController.text,
                  int.parse(ageController.text),
                  cityController.text,
                );
                SnackBar snackBar = const SnackBar(
                  content: Text('User has been added successfully !'),
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

  Future saveToUsersHive(String name, int age, String city) async {
    User user = User()
      ..name = name
      ..age = age
      ..city = city;
    debugPrint(user.name.toString());
    usersBox.add(user);
    Navigator.pop(context);
  }
}
