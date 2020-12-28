import 'package:favors/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  List<Friend> friend;

  LoginPage({Key key, this.friend}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _phoneNumber = "";
  List<StepState> _stepsState = [
    StepState.editing,
    StepState.indexed,
    StepState.indexed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Login",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Theme.of(context).primaryColor,
                        )),
              ],
            ),
            Stepper(
              type: StepperType.vertical,
              steps: <Step>[
                Step(
                    state: _stepsState[0],
                    isActive: true,
                    title: Text("Enter your Phone Number"),
                    content: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9+]")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
