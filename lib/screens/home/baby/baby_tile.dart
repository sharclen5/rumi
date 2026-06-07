import 'package:flutter/material.dart';
import 'package:rumi/models/baby.dart';
import 'package:rumi/screens/home/baby/update_baby_forms.dart';

class BabyTile extends StatelessWidget {
  final Baby baby;
  final VoidCallback onDelete;
  BabyTile({required this.baby, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Color(0xFFFDF8F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xFFE8D5B7), width: 1.5),
        ),
        margin: EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 59, 57, 52),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: baby.gender.toLowerCase() == 'male'
                      ? const Color.fromARGB(255, 140, 202, 253)
                      : const Color.fromARGB(255, 255, 146, 182),
                  child: Text(
                    baby.firstName.isNotEmpty
                        ? baby.firstName[0].toUpperCase()
                        : '?',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${baby.fullName}',
                      style: const TextStyle(
                        color: Color(0xFF363434),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Age: ${baby.ageInMonths} months',
                      style: const TextStyle(
                        color: Color(0xFF363434),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Weight: ${baby.weight} kg',
                      style: const TextStyle(
                        color: Color(0xFF363434),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Height: ${baby.height} cm',
                      style: const TextStyle(
                        color: Color(0xFF363434),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFE8D5B7), width: 1.5),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit_document,
                    color: Color(0xFF9C7A4B),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // bikin form jadi lebih tinggi
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom, // biar form naik pas keyboard muncul
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 60.0,
                          ),
                          child: UpdateBabyForms(baby: baby),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 2),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFE8D5B7), width: 1.5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF9C7A4B)),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Apakah Anda Yakin?'),
                        content: Text('Hapus Data ${baby.firstName}?'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
