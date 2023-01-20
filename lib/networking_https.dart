// ignore_for_file: prefer_const_constructors, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

TextEditingController inputName = TextEditingController();
TextEditingController inputEmail = TextEditingController();
TextEditingController inputGender = TextEditingController();

class NetworkingHttps extends StatefulWidget {
  NetworkingHttps({super.key});

  @override
  State<NetworkingHttps> createState() => _NetworkingHttpsState();
}

class _NetworkingHttpsState extends State<NetworkingHttps> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection("users");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Firebase",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data!.docs
                    .map(
                      (e) => Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image(
                                image: e["gender"].toLowerCase() == "male"
                                    ? AssetImage("images/male-30.png")
                                    : AssetImage("images/female-30.png")),
                            backgroundColor: Colors.white,
                          ),
                          title: Text(e["name"]),
                          subtitle: Text(e["email"]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: (() {
                                  inputName.text = e['name'];
                                  inputEmail.text = e['email'];
                                  inputGender.text = e['gender'];
                                  String genderItem = "";
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                        'Update User',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Name cannot be empty";
                                                }
                                                return null;
                                              },
                                              controller: inputName,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Name',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Email cannot be empty";
                                                }
                                                if (!EmailValidator.validate(
                                                    value)) {
                                                  return "Please insert correct email";
                                                }
                                                return null;
                                              },
                                              controller: inputEmail,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Email',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            DropdownSearch<String>(
                                              popupProps: PopupProps.dialog(
                                                fit: FlexFit.loose,
                                                showSelectedItems: true,
                                              ),
                                              items: ["Male", "Female"],
                                              onChanged: (value) {
                                                genderItem = value!;
                                              },
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText: "Gender",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              selectedItem: inputGender.text,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                inputName.clear();
                                                inputEmail.clear();
                                                inputGender.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                users.doc(e.id).update({
                                                  "name": inputName.text,
                                                  "email": inputEmail.text,
                                                  "gender": genderItem,
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  users.doc(e.id).delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          String genderItem = "";
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Add User',
                textAlign: TextAlign.center,
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name cannot be empty";
                        }
                        return null;
                      },
                      controller: inputName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Please insert correct email";
                        }
                        return null;
                      },
                      controller: inputEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownSearch<String>(
                      popupProps: PopupProps.dialog(
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                      ),
                      items: ["Male", "Female"],
                      onChanged: (value) {
                        genderItem = value!;
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Gender",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      selectedItem: inputGender.text,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        inputName.clear();
                        inputEmail.clear();
                        inputGender.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          users.add({
                            "name": inputName.text,
                            "email": inputEmail.text,
                            "gender": genderItem,
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
          //
        },
      ),
    );
  }
}
