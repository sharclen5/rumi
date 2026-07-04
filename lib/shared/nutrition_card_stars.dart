import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Versi B: framing "X dari 5 Bintang", sesuai istilah klinis dari wawancara
// (menu 4 bintang / 5 bintang = kelengkapan kelompok gizi dalam satu hari)

class NutritionCardStars extends StatelessWidget {
  final String uid;
  final String babyId;

  const NutritionCardStars({
    super.key,
    required this.uid,
    required this.babyId,
  });

  static const _coreGroups = {
    'karbohidrat': 'Karbohidrat',
    'protein_hewani': 'Protein Hewani',
    'protein_nabati': 'Protein Nabati',
    'sayuran': 'Sayuran',
    'buah': 'Buah',
  };

  String _todayDocId() {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return '${babyId}_$dateStr';
  }

  Set<String> _coveredGroups(Map<String, dynamic> data) {
    final meals = (data['meals'] as List?) ?? [];
    final covered = <String>{};
    for (final meal in meals) {
      if (meal is! Map) continue;
      if (meal['type'] == 'ASI') continue;
      if (meal['isEaten'] != true) continue;
      final fg = meal['foodGroup'];
      if (fg is List) {
        for (final g in fg) {
          if (g is String) covered.add(g);
        }
      }
    }
    return covered;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('recommendations')
          .doc(_todayDocId())
          .snapshots(),
      builder: (context, snapshot) {
        final hasData = snapshot.hasData && snapshot.data!.exists;
        final covered = hasData
            ? _coveredGroups(snapshot.data!.data() as Map<String, dynamic>)
            : <String>{};
        final starCount = _coreGroups.keys.where(covered.contains).length;

        return Card(
          color: const Color(0xFFFDF8F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE8D5B7), width: 1.5),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelengkapan Gizi Hari Ini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF363434),
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(),
                const SizedBox(height: 10),
                if (!hasData)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Belum ada rencana menu untuk hari ini.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
                    ),
                  )
                else ...[
                  // star row
                  Row(
                    children: List.generate(_coreGroups.length, (i) {
                      final filled = i < starCount;
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: const Color.fromARGB(255, 144, 121, 84),
                          size: 28,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$starCount dari ${_coreGroups.length} kelompok gizi terpenuhi hari ini',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF363434),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // per-group checklist
                  ..._coreGroups.entries.map((entry) {
                    final isCovered = covered.contains(entry.key);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            isCovered
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 16,
                            color: isCovered
                                ? const Color.fromARGB(255, 144, 121, 84)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 13,
                              color: isCovered
                                  ? const Color(0xFF363434)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
