import 'dart:io';
import 'dart:math';

import 'package:favors/models/friend.dart';
import 'package:favors/widgets/verification_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class LoginPage extends StatefulWidget {
  List<Friend> friend;

  LoginPage({Key key, this.friend}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentStep = 0;

  String _smsCode = "";
  String _phoneNumber = "";
  bool _showProgress = false;
  String _displayName = '';
  File _imageFile;
  bool _labeling = false;
  List<Label> _labels = List();

  List<StepState> _stepsState = [
    StepState.editing,
    StepState.indexed,
    StepState.indexed
  ];

  bool _enteringPhoneNumber() =>
      _currentStep == 0 && _stepsState[0] == StepState.editing;

  _enteringVerificationCode() =>
      _currentStep == 1 && _stepsState[1] == StepState.editing;

  _editingProfile() => _currentStep == 2 && _stepsState[2] == StepState.editing;

  void _importImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
    _labelImage();
  }

  void _labelImage() async {
    if (_imageFile == null) return;

    setState(() {
      _labeling = true;
    });

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_imageFile);

    final LabelDetector labelDetector = FirebaseVision.instance.labelDetector();

    List<Label> labels = await labelDetector.detectInImage(visionImage);

    setState(() {
      _labels = labels;
      _labeling = false;
    });
  }

  void _sendVerificationCode() async {
    // final PhoneCodeSent codeSent = (String verId, [int forceCodeResend]) {
    //   _verificationId = verId;
    //   _gotoVerificationStep();
    // }
  }

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
                    isActive: _enteringPhoneNumber(),
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
                Step(
                  state: _stepsState[1],
                  isActive: _enteringVerificationCode(),
                  title: Text("Verification code"),
                  content: VerificationCodeInput(onChanged: (value) {
                    setState(() {
                      _smsCode = value;
                    });
                  }),
                ),
                Step(
                    state: _stepsState[2],
                    isActive: _editingProfile(),
                    title: Text("Profile"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: CircleAvatar(
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile)
                                : AssetImage('assets/default_avatar.png'),
                          ),
                          onTap: () {
                            _importImage();
                          },
                        ),
                        Container(
                          height: 16.0,
                        ),
                        Text(_labeling
                            ? "Labeling the captured image ..."
                            : "Capture a image to start labeling"),
                        Container(
                          height: 32.0,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: min(_labels.length, 5),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) => Text(
                              "${_labels[index].label}, confidence: ${_labels[index].confidence}"),
                        ),
                        Container(
                          height: 16.0,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Display name"),
                          onChanged: (value) {
                            setState(() {
                              _displayName = value;
                            });
                          },
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
