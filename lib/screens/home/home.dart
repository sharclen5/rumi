import 'package:flutter/material.dart';
import 'package:rumi/services/auth.dart';
import 'package:rumi/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumi/screens/home/baby_list.dart';
import 'package:rumi/shared/loading.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: '').babies,
      initialData: null,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 113, 222, 255),
        appBar: AppBar(
          title: Text('Rumi', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepOrange,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person, color: Colors.white),
              label: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: BabyList(),
        ),
      ),
    );
  }
}
