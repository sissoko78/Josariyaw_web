import 'package:flutter/material.dart';

import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

import 'package:josariyaw/Admin/Actualit%C3%A9Page.dart';

import 'package:josariyaw/Admin/AdminPage.dart';

import 'package:josariyaw/Admin/CasjuridiquePage.dart';

import 'package:josariyaw/Admin/ConseillersPage.dart';

import 'package:josariyaw/Admin/PopulationPage.dart';

import 'package:josariyaw/Admin/Text%20de%20loi.dart';

import 'package:josariyaw/Admin/TypedeloiPage.dart';

import '../Admin/InfractionPage.dart';

class Menubar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(child: Image.asset('assets/logo_de_login.png')),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blueAccent),
            title: Text('Dashbord'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Adminpage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.account_balance, color: Colors.blueAccent),
            title: Text('Type de loi'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Typedeloipage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading:
                Icon(FontAwesomeIcons.scaleBalanced, color: Colors.blueAccent),
            title: Text('Text de loi'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Testloi()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.userTie, color: Colors.blueAccent),
            title: Text('Conseiller juridique'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Conseillerspage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.person, color: Colors.blueAccent),
            title: Text('Population'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Populationpage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading:
                Icon(FontAwesomeIcons.folderOpen, color: Colors.blueAccent),
            title: Text('Infractions'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Infractionpage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading:
                Icon(Icons.folder_shared_outlined, color: Colors.blueAccent),
            title: Text('Cas juridique'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Casjuridiquepage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blueAccent),
            title: Text('Actualité'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Actualitepage()));
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blueAccent),
            title: Text('Parametre'),
          )
        ],
      ),
    );
  }
}
