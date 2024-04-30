import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vault_testing/widgets/bottomnavigationbar.dart';
import 'package:vault_testing/widgets/constants.dart';
import 'package:vault_testing/widgets/reusable_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SetMasterKey extends StatefulWidget {
  static const String id = 'setMasterKey_screen';
  const SetMasterKey({super.key});

  @override
  State<SetMasterKey> createState() => _SetMasterKeyState();
}

class _SetMasterKeyState extends State<SetMasterKey> {
  bool showSpinner = false;
  final masterKey = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    masterKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: kActiveCardColor
                    //     gradient: LinearGradient(colors: [
                    //   Color(0xff9BA8AB),
                    //   Color(0xff8B9799),
                    //   Color(0xff7C8688),
                    // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Set your Master Key',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Enter Master key", Icons.key, true, masterKey),
                        const SizedBox(
                          height: 20,
                        ),
                        UIButton(context, "Set", () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final newMaster = await FirebaseFirestore.instance
                                .collection('MasterKey')
                                .add({
                              'UserID': FirebaseAuth.instance.currentUser!.uid,
                              'MasterKey': masterKey.text.trim(),
                            });
                            if (newMaster != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Bottom(),
                                ),
                              );
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            print(e);
                          }
                        }),
                        const Text(
                          'This Master Key will allow you to view your passwords remember it well !',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
