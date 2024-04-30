import 'package:flutter/material.dart';
import 'package:vault_testing/Screens/PasswordHomepage.dart';
import 'package:vault_testing/Screens/Settings.dart';
import 'package:vault_testing/Screens/add.dart';
import 'package:vault_testing/Screens/home.dart';
import 'package:vault_testing/Screens/statistics.dart';
import 'package:vault_testing/widgets/constants.dart';

class Bottom extends StatefulWidget {
  static const String id = 'Bottom_screen';
  @override
  State<Bottom> createState() => _BottomState();

  const Bottom({Key? key}) : super(key: key);
}

class _BottomState extends State<Bottom> {
  int currentIndex = 0;

  List Screen = [Home(), Statistics(), PasswordHomepage(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, Add_Screen.id);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kBottomContainerColor,
        // backgroundColor: Colors.green[300],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: kBackGroundColor,
        // color: Colors.greenAccent[700],
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: currentIndex == 0 ? Colors.white : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: currentIndex == 1 ? Colors.white : Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                child: Icon(
                  Icons.password,
                  size: 30,
                  color: currentIndex == 2 ? Colors.white : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
                child: Icon(
                  Icons.settings,
                  size: 30,
                  color: currentIndex == 3 ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
