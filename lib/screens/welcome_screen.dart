import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      children: [

        
        Stack(
          children: [


            Positioned.fill(
              child: Image.asset(
                "assests/museum.jpg",
                fit: BoxFit.cover,
              ),
            ),


            Positioned.fill(
              child: Container(

              ),
            ),


            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [


                  Image.asset(
                    "assests/louvre.png",
                    width: 900,
                  ),

                  const SizedBox(height: 20),


                  Text(
                    "BOOK UR MUSEUM !",
                    style: GoogleFonts.archivoBlack(
                      color: Colors.white,
                      fontSize: 30,
                      letterSpacing: 2,
                      decoration: TextDecoration.none
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

          ],
        ),


        const HomeScreen(),
      ],
    );
  }
}