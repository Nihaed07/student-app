import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/settings.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F1323),
        foregroundColor: Colors.white,
        title: Text(
          'Privacy & Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0F1323),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Icon(Icons.security, size: 200, color: Colors.white.withOpacity(0.3)),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Text(
                "We built this app to help schools record and manage student attendance efficiently. To do that, we collect and process certain information. This policy explains exactly what we collect, why we collect it, and how we protect it—without hiding anything behind legal jargon.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
