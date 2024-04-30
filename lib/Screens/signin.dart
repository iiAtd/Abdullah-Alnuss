import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vault_testing/Screens/signup.dart';
import 'package:vault_testing/widgets/constants.dart';
import '../widgets/reusable_widget.dart';
import '../widgets/bottomnavigationbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  static const String id = 'signIn_screen';
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showSpinner = false;
  final password = TextEditingController();
  final email = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: kActiveCardColor
              // gradient: LinearGradient(colors: [
              //   Colors.white,
              //   Colors.green.shade50,
              //   Colors.green.shade100,
              //   Colors.green.shade200,
              //   Colors.green.shade300,
              //   Colors.green.shade400,
              // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget('images/vault_logo.png'),
                  const SizedBox(
                    height: 50,
                  ),
                  reusableTextField(
                      "Enter your Email", Icons.person_outline, false, email),
                  const SizedBox(
                    height: 25,
                  ),
                  reusableTextField("Enter your Password", Icons.lock_outline,
                      true, password),
                  const SizedBox(
                    height: 5,
                  ),
                  UIButton(context, "LOG IN", () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim());
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Bottom(),
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
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
