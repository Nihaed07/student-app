import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/settings.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
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
          'About Us',
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Text(
                'We created this platform because schools waste hours every week on tasks that should take minutes. Manual registers get lost, Excel sheets get messy, and tracking daily attendance becomes a constant headache. So we designed a system that works the way people actually need it to—simple, reliable, and accessible from anywhere.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                '-What We Do-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  // Icon(Icons.stars, color: Colors.white, size: 20),
                  SizedBox(width: 5),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Text(
                    '* Provide a clean and intuitive way for teachers to mark daily attendance in seconds.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Text(
                    '* Offer real-time tracking so parents and admins always know what’s happening.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Text(
                    '* Generate clear reports that help schools understand student performance and activity.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Text(
                    '*Sync data securely across devices without the usual technical friction.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '-Our Goal-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    child: Text(
                      'To replace outdated attendance methods with a modern, transparent, and efficient system that saves time and reduces errors—while giving everyone involved a better experience.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                Center(
                  child: Text(
                    '-Why It Matters-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    child: Text(
                      'Accurate attendance isn’t just about counting who’s present. It affects academic performance, parent communication, school planning, and overall discipline. By removing the busywork, we let teachers focus on what actually matters: teaching.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
