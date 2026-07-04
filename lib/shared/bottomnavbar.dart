import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumi/screens/home/recommendation/add_recommendation.dart';
import 'dart:convert';
import 'package:rumi/models/baby.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Color(0xFF363434),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Beranda',
              index: 0,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              icon: Icons.recommend_rounded,
              label: 'Rekomendasi',
              index: 1,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              icon: Icons.add_circle_outline,
              label: 'Buat Rencana',
              index: 2,
              currentIndex: currentIndex,
              onTap: (i) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (outerContext) => Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Provider<List<Baby>?>.value(
                      value: Provider.of<List<Baby>?>(context, listen: false),
                      child: const AddRecommendation(),
                    ),
                  ),
                );
              },
            ),
            _NavItem(
              icon: Icons.history_rounded,
              label: 'Riwayat',
              index: 3,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _AvatarNavItem(
              index: 4,
              currentIndex: currentIndex,
              onTap: onTap,
              photoUrl: photoUrl,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    const activeColor = Color.fromARGB(255, 242, 218, 177);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          size: 26,
          color: isSelected ? activeColor : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _AvatarNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final Function(int) onTap;
  final String? photoUrl;

  const _AvatarNavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    const activeColor = Color.fromARGB(255, 242, 218, 177);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: photoUrl != null
            ? CircleAvatar(
                radius: 14,
                backgroundImage: photoUrl!.startsWith('data:image')
                    ? MemoryImage(base64Decode(photoUrl!.split(',').last))
                    : NetworkImage(photoUrl!) as ImageProvider,
              )
            : CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFE8C99A),
                child: Icon(Icons.person, color: Color(0xFF8B6F47), size: 16),
              ),
      ),
    );
  }
}
