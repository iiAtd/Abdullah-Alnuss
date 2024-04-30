import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vault_testing/Screens/ViewPasswordPage.dart';
import 'package:vault_testing/Screens/addPassword_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:vault_testing/widgets/bottomnavigationbar.dart';
import 'package:vault_testing/widgets/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PasswordHomepage extends StatefulWidget {
  static const String id = 'passwordHome_screen';
  const PasswordHomepage({super.key});

  @override
  _PasswordHomepageState createState() => _PasswordHomepageState();
}

class _PasswordHomepageState extends State<PasswordHomepage> {
  bool showSpinner = false;
  List<QueryDocumentSnapshot> passwordData = [];

  void getPasswordData() async {
    try {
      setState(() {
        showSpinner = true;
      });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Passwords')
          .where("UserID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      passwordData.addAll(querySnapshot.docs);
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPasswordData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Vault Passwords",
                        style: TextStyle(
                            fontFamily: "Title",
                            fontSize: 25,
                            color: Colors.black),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: kBottomContainerColor,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(context, AddPasswords.id);
                        },
                        label: const Text(
                          'New',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kInActiveCardColor,
                ),
                width: size.width,
                height: size.height * 0.7,
                child: ListView.builder(
                  itemCount: passwordData.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        const Divider(
                          endIndent: 150,
                          indent: 150,
                          thickness: 0.8,
                          color: kBottomContainerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ViewPassword(
                                    passwordData: passwordData[i],
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Warning',
                                      desc: 'Are you sure delete ?',
                                      btnOkOnPress: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Passwords')
                                            .doc(passwordData[i].id)
                                            .delete();
                                        Navigator.pushReplacementNamed(
                                            context, Bottom.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Password deleted successfully')),
                                        );
                                      },
                                      btnCancelOnPress: () {})
                                  .show();
                            },
                            child: ListTile(
                              title: Text(
                                "${passwordData[i]['AppName']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Subtitle',
                                ),
                              ),
                              leading: Container(
                                  height: 48,
                                  width: 48,
                                  child: const CircleAvatar(
                                    backgroundColor: kAltBackGroundColor,
                                  )),
                              subtitle: passwordData[i]['UserName'] != ""
                                  ? Text(
                                      "${passwordData[i]['UserName']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Subtitle',
                                      ),
                                    )
                                  : const Text(
                                      "No username specified",
                                      style: TextStyle(
                                        fontFamily: 'Subtitle',
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
