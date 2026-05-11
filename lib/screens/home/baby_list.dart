import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class BabyList extends StatefulWidget {
  const BabyList({super.key});

  @override
  State<BabyList> createState() => _BabyListState();
}

class _BabyListState extends State<BabyList> {
  @override
  Widget build(BuildContext context) {
    final babies = Provider.of<QuerySnapshot?>(context);
    // debugPrint(babies?.docs.toString());
    for (var doc in babies!.docs) {
      debugPrint(doc.data().toString());
    }

    return const Placeholder();
  }
}
