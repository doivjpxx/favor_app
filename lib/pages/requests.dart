import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favors/models/favor.dart';
import 'package:favors/models/friend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class RequestsFavorPage extends StatefulWidget {
  final List<Friend> friends;

  RequestsFavorPage({Key key, this.friends}) : super(key: key);

  @override
  RequestsFavorPageState createState() => RequestsFavorPageState();
}

class RequestsFavorPageState extends State<RequestsFavorPage> {
  final _formKey = GlobalKey<FormState>();
  Friend _selectedFriend;
  DateTime _dueDate;
  String _description;
  List<Friend> friends;

  static RequestsFavorPageState of(BuildContext context) {
    return context.ancestorStateOfType(TypeMatcher<RequestsFavorPageState>());
  }

  void save(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final currentUser = await FirebaseAuth.instance.currentUser();

      _saveFavorOnFirebase(Favor(
          to: _selectedFriend.number,
          description: _description,
          dueDate: _dueDate,
          friend: Friend(
              name: currentUser.displayName,
              number: currentUser.phoneNumber,
              photoURL: currentUser.photoUrl)));

      // Navigate to home
      Navigator.pop(context);
    }
  }

  void _saveFavorOnFirebase(Favor favor) async {
    await Firestore.instance
        .collection('favors')
        .document()
        .setData(favor.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Requesting a favor"),
          leading: CloseButton(),
          actions: <Widget>[
            FlatButton(
              child: Text("SAVE"),
              textColor: Colors.white,
              onPressed: () {
                RequestsFavorPageState.of(context).save(context);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              DropdownButtonFormField(
                items: widget.friends
                    .map((f) => DropdownMenuItem(
                          child: Text(f.name),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              TextFormField(
                maxLength: 5,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
              ),
              DateTimePickerFormField(
                inputType: InputType.both,
                format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                editable: false,
                decoration: InputDecoration(
                  labelText: 'Date/Time',
                  hasFloatingPlaceholder: false,
                ),
                onChanged: (dt) {},
              )
            ],
          ),
        ));
  }
}
