import 'package:flutter/material.dart';
import 'package:rumi/models/user.dart';

class UserTile extends StatelessWidget {
  final UserProfile user;
  UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Color.fromARGB(255, 0, 138, 218),
            child: Text(
              user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          title: Text('${user.firstName} ${user.lastName}'),
          subtitle: Text(user.phone),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // edit — wire up later
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // delete — wire up later
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
