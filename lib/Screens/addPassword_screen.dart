import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_strength/password_strength.dart';
import 'package:vault_testing/Screens/home.dart';
import 'package:vault_testing/widgets/bottomnavigationbar.dart';
import 'package:vault_testing/widgets/constants.dart';
import '../passwordGenerator.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPasswords extends StatefulWidget {
  static const String id = 'addPasswords_screen';
  const AddPasswords({
    super.key,
  });

  @override
  _AddPasswordsState createState() => _AddPasswordsState();
}

class _AddPasswordsState extends State<AddPasswords> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final appNameController = TextEditingController();
  final userNameController = TextEditingController();
  late String passwordText;
  late String appNameText;
  late String userNameText;
  final _auth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot> masterKeyData = [];
  late String keyString;
  final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);

  @override
  void initState() {
    getCurrentUser();
    getMasterKey();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getMasterKey() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('MasterKey')
        .where("UserID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    masterKeyData.addAll(querySnapshot.docs);
    setState(() {});
  }

  double passwordStrength = 0.0;
  Color passwordStrengthBarColor = Colors.red;
  bool obscureText = true;
  String show_hide = 'Show Password';
  var scaffoldKey = GlobalKey<ScaffoldState>();

  checkPassStrength(String pass) {
    setState(() {
      passwordStrength = estimatePasswordStrength(pass);
      Color passwordStrengthBarColor = Colors.red;
      if (passwordStrength < 0.4) {
        passwordStrengthBarColor = Colors.red;
      } else if (passwordStrength > 0.4 && passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.deepOrangeAccent;
      } else if (passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.orange;
      } else if (passwordStrength > 0.7 || passwordStrength == 0.7) {
        passwordStrengthBarColor = Colors.green;
      }
      setState(() {
        this.passwordStrengthBarColor = passwordStrengthBarColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 28,
      ),
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  margin: EdgeInsets.only(top: size.height * 0.001),
                  child: const Text(
                    "Add Password",
                    style: TextStyle(
                        fontFamily: "Title", fontSize: 32, color: Colors.black),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kInActiveCardColor,
                    // color: Colors.white,
                  ),
                  height: size.height,
                  width: size.width * 1,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter valid title';
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: kAltBackGroundColor),
                            ),
                            labelText: "App name/ Website",
                            labelStyle: const TextStyle(
                                fontFamily: "Subtitle", color: Colors.white),
                          ),
                          controller: appNameController,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            appNameText = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter valid Username';
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: kAltBackGroundColor),
                            ),
                            labelText: "User Name/Email",
                            labelStyle: const TextStyle(
                                fontFamily: "Subtitle", color: Colors.white),
                          ),
                          controller: userNameController,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            userNameText = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (
                            pass,
                          ) {
                            checkPassStrength(pass);
                            passwordText = pass;
                          },
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: kAltBackGroundColor),
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle(
                              fontFamily: "Subtitle",
                              color: Colors.white,
                            ),
                          ),
                          controller: passwordController,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                String pass = randomAlphaNumeric(10);
                                passwordController.text = pass;
                                passwordText = pass;
                                checkPassStrength(pass);
                              },
                              child: const Text(
                                'Generate',
                                style: TextStyle(
                                    color: kAltBackGroundColor, fontSize: 17),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                  if (obscureText) {
                                    show_hide = 'Show Password';
                                  } else {
                                    show_hide = 'Hide Password';
                                  }
                                });
                              },
                              child: Text(
                                show_hide,
                                style: const TextStyle(
                                    color: kAltBackGroundColor, fontSize: 17),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: passwordController.text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Copied to Clipboard"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text(
                                'Copy',
                                style: TextStyle(
                                    color: kAltBackGroundColor, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 10,
                            width: passwordStrength == 0
                                ? 5
                                : MediaQuery.of(context).size.width *
                                    passwordStrength,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: passwordStrengthBarColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBottomContainerColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          try {
            setState(() {
              showSpinner = true;
            });
            encryptPass(passwordController.text);
            await FirebaseFirestore.instance.collection('Passwords').add({
              'AppName': appNameText,
              'Password': passwordText,
              'UserName': userNameText,
              'UserID': _auth.currentUser!.uid,
              'TimeStamp': DateTime.now(),
              'IV': iv.base64,
            });
            Navigator.pushNamed(context, Bottom.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password add successfully')),
            );
            setState(() {
              showSpinner = false;
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to Password add ')),
            );
            setState(() {
              showSpinner = false;
            });
            print(e);
          }
        },
      ),
    );
  }

  encryptPass(String text) {
    if (masterKeyData.isNotEmpty) {
      String keyString = masterKeyData[0].get('MasterKey');
      if (keyString.length < 32) {
        int count = 32 - keyString.length;
        for (var i = 0; i < count; i++) {
          keyString += ".";
        }
      }
      final keyData = encrypt.Key.fromUtf8(keyString);
      final plainText = text;
      final encrypter = encrypt.Encrypter(encrypt.AES(keyData));
      final e = encrypter.encrypt(plainText, iv: iv);
      passwordText = e.base64.toString();
    } else {
      // Handle the case where masterKeyData is empty
    }
  }
}
