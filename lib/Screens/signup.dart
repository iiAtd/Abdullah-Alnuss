import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vault_testing/Screens/SetMasterKey.dart';
import 'package:vault_testing/widgets/constants.dart';
import '../widgets/reusable_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class SignUpScreen extends StatefulWidget {
  static const String id = 'signUp_screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: kActiveCardColor
              //     gradient: LinearGradient(colors: [
              //   Color(0xff9BA8AB),
              //   Color(0xff8B9799),
              //   Color(0xff7C8688),
              // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                      "Enter Email", Icons.person_outline, false, email),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                      "Enter Password", Icons.lock_outlined, true, password),
                  const SizedBox(
                    height: 20,
                  ),
                  UIButton(context, "Sign Up", () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim());
                      if (newUser != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetMasterKey(),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
