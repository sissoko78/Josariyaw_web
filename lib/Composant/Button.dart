import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Function()? onTap;
  const Button({super.key, required this.onTap});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: 100),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              'Connexion',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
