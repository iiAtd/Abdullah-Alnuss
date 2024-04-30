import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:vault_testing/widgets/constants.dart';

class ViewPassword extends StatefulWidget {
  static const String id = 'viewPassword_screen';
  final QueryDocumentSnapshot passwordData;
  const ViewPassword({super.key, required this.passwordData});

  @override
  _ViewPasswordState createState() => _ViewPasswordState();
}

class _ViewPasswordState extends State<ViewPassword> {
  final masterKey = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  List<QueryDocumentSnapshot> passwordData = [];
  List<QueryDocumentSnapshot> masterKeyData = [];
  String obscureText = '*******';
  bool decrypt = false;
  late final String passFire;

  void getPasswordData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Passwords')
        .where("UserID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    passwordData.addAll(querySnapshot.docs);
    setState(() {});
  }

  Future getMasterKey() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('MasterKey')
        .where("UserID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    masterKeyData.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPasswordData();
    getMasterKey();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kBottomContainerColor),
          toolbarHeight: 27,
          backgroundColor: kInActiveCardColor,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  height: size.height * 0.23,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kInActiveCardColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("${widget.passwordData['AppName']}",
                            style: TextStyle(
                                fontFamily: "Title",
                                fontSize: 32,
                                color: Colors.white)),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Username",
                        style: TextStyle(fontFamily: 'Title', fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                      child: Text(
                        "${widget.passwordData['UserName']}",
                        style: TextStyle(
                          fontFamily: 'Subtitle',
                          fontSize: 20,
                          // color: Colors.black54
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Password",
                                style: TextStyle(
                                    fontFamily: 'Title', fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                              child: Text(
                                decrypt ? passFire : obscureText,
                                style: TextStyle(
                                  fontFamily: 'Subtitle',
                                  fontSize: 20,
                                  // color: Colors.black54
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (!decrypt) {
                              buildShowDialogBox(context);
                            } else {
                              setState(() {
                                decrypt = !decrypt;
                              });
                            }
                          },
                          icon: decrypt
                              ? Icon(Icons.lock_open)
                              : Icon(Icons.lock),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future buildShowDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Master Key"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "To see the password enter your Master Key:",
                style: TextStyle(fontFamily: 'Subtitle'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  maxLength: 32,
                  decoration: InputDecoration(
                      hintText: "Master Key",
                      hintStyle: TextStyle(fontFamily: "Subtitle"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16))),
                  controller: masterKey,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (masterKey.text == masterKeyData[0]['MasterKey']) {
                  final encryptedPassword = widget.passwordData['Password'];
                  final ivBase64 = widget.passwordData['IV'];
                  final decryptedPassword =
                      decryptPass(encryptedPassword, ivBase64);
                  setState(() {
                    decrypt = true;
                    passFire = decryptedPassword;
                  });
                }
              },
              child: Text("DONE"),
            )
          ],
        );
      },
    );
  }

  decryptPass(String encryptedText, String ivBase64) {
    if (masterKeyData.isNotEmpty) {
      String keyString = masterKeyData[0].get('MasterKey');
      if (keyString.length < 32) {
        int count = 32 - keyString.length;
        for (var i = 0; i < count; i++) {
          keyString += ".";
        }
      }
      final keyData = encrypt.Key.fromUtf8(keyString);
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      final iv = encrypt.IV.fromBase64(ivBase64);
      final encrypter = encrypt.Encrypter(encrypt.AES(keyData));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    }
  }
}
