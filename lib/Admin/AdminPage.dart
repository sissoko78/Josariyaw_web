import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:josariyaw/Composant/Navbarlateral.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';

class Adminpage extends StatefulWidget {
  Adminpage({super.key});

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  AuthService authService = AuthService();
  String? imageUrl;
  String? nom;
  String? prenom;

  int countConseillers = 0;
  int countPopulations = 0;
  int countCasJuridique = 0;
  Map<int, int> monthlyConnections = {};

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _countUsersByRole('conseillers');
    _countUsersByRole('civil');
    _countCasJuridique();
    _loadMonthlyConnections();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          imageUrl = userDoc['imageUrl'];
          nom = userDoc['nom'];
          prenom = userDoc['prenom'];
        });
      }
    }
  }

  Future<void> _countUsersByRole(String role) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role)
        .get();
    setState(() {
      if (role == 'conseillers') {
        countConseillers = snapshot.docs.length;
      } else if (role == 'civil') {
        countPopulations = snapshot.docs.length;
      }
    });
  }

  Future<void> _countCasJuridique() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('cas_juridiques').get();
    setState(() {
      countCasJuridique = snapshot.docs.length;
    });
  }

  Future<void> _loadMonthlyConnections() async {
    for (int month = 1; month <= 12; month++) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_connections')
          .where('month', isEqualTo: month)
          .get();
      setState(() {
        monthlyConnections[month] = snapshot.docs.length;
      });
    }
  }

  Widget _buildDashboardCard(String title, IconData icon, int count) {
    return SizedBox(
      width: 100,
      height: 200,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blueAccent),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '$count',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget _buildMonthlyConnectionsChart() {
    return SizedBox(
      height: 200, // Explicitly set the height for the LineChart
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final monthNames = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec'
                  ];
                  return Text(monthNames[value.toInt() - 1]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: monthlyConnections.entries
                  .map((entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                  .toList(),
              isCurved: true,
              barWidth: 3,
              color: Colors.blueAccent,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blueAccent.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Menubar(),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : AssetImage('assets/default_profile.png')
                                    as ImageProvider,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$nom $prenom',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Utilisateur connecté',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await authService.Deconnexion(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Déconnexion'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildDashboardCard('Populations',
                            FontAwesomeIcons.peopleArrows, countPopulations),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildDashboardCard('Conseillers',
                            FontAwesomeIcons.userNurse, countConseillers),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildDashboardCard('Cas Juridique',
                            Icons.folder_shared_outlined, countCasJuridique),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Connexions mensuelles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: null,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
