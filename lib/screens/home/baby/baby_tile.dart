import 'package:flutter/material.dart';
import 'package:rumi/models/baby.dart';

class BabyTile extends StatelessWidget {
  final Baby baby;
  final VoidCallback onDelete;
  BabyTile({required this.baby, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.deepOrange,
            child: Text(
              baby.name.isNotEmpty ? baby.name[0].toUpperCase() : '?',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          title: Text(baby.name),
          subtitle: Text('Age: ${baby.age} months'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Weight: ${baby.weight} kg'),
                  Text('Height: ${baby.height} cm'),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Data Bayi'),
                      content: Text('Hapus ${baby.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) onDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
