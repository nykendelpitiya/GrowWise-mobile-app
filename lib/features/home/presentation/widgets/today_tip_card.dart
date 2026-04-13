import 'package:flutter/material.dart';
import 'home_colors.dart';

class TodayTipCard extends StatelessWidget {
  const TodayTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       
        color: const Color(0xFFFFF8E1),

        borderRadius: BorderRadius.circular(20),

       
        border: Border.all(
          color: const Color(0xFFFDE68A),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Icon(
            Icons.lightbulb_outline,
            color: Color(0xFFF59E0B),
            size: 22,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today Tip",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kTextDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Rain is expected today. Avoid extra watering and check soil moisture before plant care.",
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: kTextLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}