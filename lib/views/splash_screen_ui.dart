// ignore_for_file: prefer_const_constructors, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monney_tracking_project/views/stastapp_ui.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  void initState() {
    Future.delayed(
      //เวลาที่หน่วง
      Duration(
        seconds: 3,
      ),
      //เมื่อครบเวลาแล้วจะให้ทำอะไร
      //ในที่นี้จะให้เปิดไปหน้าจอ LoginUi แบบ ไม่สามารถย้อนกลับได้
      () => Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => StastappUi(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 3, 74),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Text(
              'Money Tracking',
              style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  color: Color.fromARGB(255, 250, 250, 250),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Text(
              'รายรับรายจ่ายของฉัน',
              style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: Color.fromARGB(255, 250, 250, 250),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Created by 6419410021',
              style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: Color.fromARGB(255, 250, 250, 250),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
