import 'package:flutter/material.dart';
import 'dart:convert';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String? photoUrl;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.deepOrange,
      elevation: 0.0,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 1 || index == 2)
          return; // disable page Rekomendasi sama Riwayat buat sementara
        onTap(index);
      },
      selectedItemColor: const Color.fromARGB(255, 113, 222, 255),
      unselectedItemColor: Colors.white,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.recommend),
          label: 'Rekomendasi',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Center(
            child: CircleAvatar(
              radius: 12,
              backgroundImage:
                  photoUrl != null && photoUrl!.startsWith('data:image')
                  ? MemoryImage(base64Decode(photoUrl!.split(',').last))
                  : const AssetImage('assets/images/placeholder.jpg')
                        as ImageProvider,
            ),
          ),
          label: 'You',
        ),
      ],
    );
  }
}
