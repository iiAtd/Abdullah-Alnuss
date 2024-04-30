import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vault_testing/Screens/signin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vault_testing/widgets/bottomnavigationbar.dart';
import 'package:vault_testing/widgets/constants.dart';
import 'package:vault_testing/widgets/icon_content.dart';
import 'package:vault_testing/widgets/reusableCard.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

enum Cards {
  cMasterKey,
  cProfile,
  cFollowUs,
  cHelp,
  cRecords,
}

class Settings extends StatefulWidget {
  static const String id = 'settings_screen';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  bool showSpinner = false;
  final oldMasterKey = TextEditingController();
  final newMasterKey = TextEditingController();
  List<QueryDocumentSnapshot> masterKeyData = [];
  Cards? selectedCard;
  DocumentSnapshot<Object?>? masterKeyDoc;

  Future getMasterKey() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('MasterKey')
        .where("UserID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    masterKeyData.addAll(querySnapshot.docs);
    if (querySnapshot.docs.isNotEmpty) {
      masterKeyDoc = querySnapshot.docs.first;
    }
    setState(() {});
  }

  Future changeMasterKey() async {
    if (masterKeyDoc != null) {
      await masterKeyDoc!.reference.update({'MasterKey': newMasterKey.text});
      getMasterKey(); // Fetch the updated master key from the database
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Master Key changed successfully')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    getMasterKey();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Settings",
                      style: TextStyle(
                          fontFamily: "Title", fontSize: 25, color: Colors.black),
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: kBottomContainerColor,
                      icon: const Icon(
                        FontAwesomeIcons.signOut,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          FirebaseAuth.instance.signOut();
                          Navigator.popAndPushNamed(context, SignIn.id);
                          setState(() {
                            showSpinner = false;
                          });
                        }catch(e){
                          setState(() {
                            showSpinner = false;
                          });
                          print(e);
                        }
                      },
                      label: const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          selectedCard = Cards.cMasterKey;
                        });
                      },
                      onTapUp: (details) {
                        setState(() {
                          selectedCard = null;
                        });
                      },
                      onTap: () {
                        buildShowDialogBox(context);
                      },
                      child: ReusableCard(
                        colour: selectedCard == Cards.cMasterKey
                            ? kActiveCardColor
                            : kInActiveCardColor,
                        cardChild: const IconContent(
                            icon: FontAwesomeIcons.key, label: 'MasterKey'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          selectedCard = Cards.cProfile;
                        });
                      },
                      onTapUp: (details) {
                        setState(() {
                          selectedCard = null;
                        });
                      },
                      child: ReusableCard(
                        colour: selectedCard == Cards.cProfile
                            ? kActiveCardColor
                            : kInActiveCardColor,
                        cardChild: const IconContent(
                            icon: Icons.account_circle, label: 'Profile'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          selectedCard = Cards.cFollowUs;
                        });
                      },
                      onTapUp: (details) {
                        setState(() {
                          selectedCard = null;
                        });
                      },
                      child: ReusableCard(
                        colour: selectedCard == Cards.cFollowUs
                            ? kActiveCardColor
                            : kInActiveCardColor,
                        cardChild: const IconContent(
                            icon: FontAwesomeIcons.instagram, label: 'Follow us'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          selectedCard = Cards.cHelp;
                        });
                      },
                      onTapUp: (details) {
                        setState(() {
                          selectedCard = null;
                        });
                      },
                      child: ReusableCard(
                        colour: selectedCard == Cards.cHelp
                            ? kActiveCardColor
                            : kInActiveCardColor,
                        cardChild:
                            const IconContent(icon: Icons.help, label: 'Help'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          selectedCard = Cards.cRecords;
                        });
                      },
                      onTapUp: (details) {
                        setState(() {
                          selectedCard = null;
                        });
                      },
                      child: ReusableCard(
                        colour: selectedCard == Cards.cRecords
                            ? kActiveCardColor
                            : kInActiveCardColor,
                        cardChild:
                            const IconContent(icon: Icons.list, label: 'Records'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future buildShowDialogBox(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change your Master Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('To change your Master Key you have to enter your old Master Key:',
                  style: TextStyle(fontFamily: 'Subtitle')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  maxLength: 32,
                  decoration: InputDecoration(
                    hintText: 'Old Master Key',
                    hintStyle: TextStyle(fontFamily: 'Subtitle'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  controller: oldMasterKey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  maxLength: 32,
                  decoration: InputDecoration(
                    hintText: 'New Master Key',
                    hintStyle: TextStyle(fontFamily: 'Subtitle'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  controller: newMasterKey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (oldMasterKey.text.isNotEmpty && masterKeyDoc != null) {
                  String? currentMasterKey = (masterKeyDoc?.data() as Map<String, dynamic>?)?['MasterKey'] as String?;
                  if (oldMasterKey.text == currentMasterKey) {
                    // Change the master key
                    await changeMasterKey();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Master Key changed successfully')),
                    );
                  } else {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('The old master key is incorrect')),
                    );
                  }
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the old master key')),
                  );
                }
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
