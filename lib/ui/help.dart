import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/settings.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
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
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0F1323),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Text(
                'For any assistance, please contact us at:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                      size: 68,
                    ),
                  ),

                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // color: Colors.white,
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(
                    child: Icon(Icons.call, color: Colors.white, size: 80),
                  ),

                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(
                    child: Icon(Icons.facebook, color: Colors.white, size: 100),
                  ),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.mail_sharp,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 55),
                child: Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 95),
              Text(
                'Call',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 70),
              Text(
                'Facebook',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 75),
              Text(
                'Mail',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
