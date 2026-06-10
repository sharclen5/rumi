import 'package:flutter/material.dart';

class MealCard extends StatefulWidget {
  const MealCard({super.key});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final PageController _controller = PageController(viewportFraction: 0.95);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _controller,
        children: [
          _mealCard(
            'Jadwal Berikutnya',
            'Sarapan',
            '07.00',
            'Bubur Ayam Wortel',
          ),
          _mealCard(
            'Jadwal Makan Siang',
            'Makan Siang',
            '12.00',
            'Nasi Tim Ikan',
          ),
          _mealCard(
            'Jadwal Makan Malam',
            'Makan Malam',
            '18.00',
            'Pure Labu Kuning',
          ),
        ],
      ),
    );
  }

  Widget _mealCard(
    String badge,
    String mealType,
    String time,
    String mealName,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4),
      color: Color(0xFFFDF8F2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFFE8D5B7), width: 1.5),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 144, 121, 84),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '$mealType · $time',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      mealName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: const Color.fromARGB(255, 122, 105, 95),
                    child: Icon(
                      Icons.lunch_dining,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _chip('Protein 30%'),
                    _chip('Karbo 50%'),
                    _chip('Lemak 20%'),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Lihat detail →',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 144, 121, 84),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 138, 218).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }
}
