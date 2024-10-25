import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:josariyaw/Civil/Accueilhome.dart';
import 'package:josariyaw/Civil/Actualitepage.dart';
import 'package:josariyaw/Civil/Discussionpage.dart';
import 'package:josariyaw/Civil/SuivisCaspage.dart';

class Civilhome extends StatefulWidget {
  const Civilhome({super.key});

  @override
  State<Civilhome> createState() => _CivilhomeState();
}

class _CivilhomeState extends State<Civilhome> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    Accueilhome(),
    Suiviscaspage(),
    Discussionpage(),
    Actualitepage(),
  ];

  List<IconData> data = [
    Icons.home_outlined,
    Icons.folder_copy_outlined,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.infoCircle,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F3F3),
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue,
          child: Container(
            height: 70,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(data.length, (i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = i;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      border: i == selectedIndex
                          ? Border(
                              top: BorderSide(width: 3.0, color: Colors.white),
                            )
                          : null,
                      gradient: i == selectedIndex
                          ? LinearGradient(
                              colors: [Color(0xFFE1F3F3), Colors.blue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                    ),
                    child: Icon(
                      data[i],
                      size: 35,
                      color: i == selectedIndex
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
