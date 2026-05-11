import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 113, 222, 255),
      child: Center(
        child: SpinKitSquareCircle(color: Colors.deepOrange, size: 50.0),
      ),
    );
  }
}
