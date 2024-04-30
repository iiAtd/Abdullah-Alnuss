import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vault_testing/Screens/PasswordHomepage.dart';
import 'package:vault_testing/Screens/SetMasterKey.dart';
import 'package:vault_testing/Screens/Settings.dart';
import 'package:vault_testing/Screens/add.dart';
import 'package:vault_testing/Screens/addPassword_screen.dart';
import 'package:vault_testing/Screens/home.dart';
import 'package:vault_testing/Screens/signup.dart';
import 'package:vault_testing/Screens/statistics.dart';
import 'package:vault_testing/widgets/bottomnavigationbar.dart';
import 'Screens/signin.dart';
import 'data/model/add_date.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAfD5GOO8aCHEI6MrCL6ijtdaY43FBwQBk",
          appId: "1:910265701744:android:416f0c9d0c31af6b586bb5",
          messagingSenderId: "910265701744",
          projectId: "vault-62407"));
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SignIn.id,
      routes: {
        SignIn.id: (context) => SignIn(),
        SignUpScreen.id: (context) => SignUpScreen(),
        Home.id: (context) => Home(),
        Statistics.id: (context) => Statistics(),
        Add_Screen.id: (context) => Add_Screen(),
        PasswordHomepage.id: (context) => PasswordHomepage(),
        AddPasswords.id: (context) => AddPasswords(),
        Bottom.id: (context) => Bottom(),
        Settings.id: (context) => Settings(),
        SetMasterKey.id: (context) => SetMasterKey(),
      },
    );
  }
}
