import 'package:flutter/material.dart';
import 'home_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Nusith",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Welcome back to GrowWise",
                style: TextStyle(
                  fontSize: 13,
                  color: kTextLight,
                ),
              ),
            ],
          ),
        ),

       
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            
            gradient: const LinearGradient(
              colors: [
                Color(0xFFBBF7D0),
                Color(0xFF4ADE80),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}