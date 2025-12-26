import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/presentation/bottomnav.dart';
import 'package:flutter_application_1/data/models.dart';

class TextForm extends StatefulWidget {
  const TextForm({super.key});

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  final List<String> div = ['A', 'B', 'C', 'D', 'E'];
  String? selectedDiv;
  final ImagePicker picker = ImagePicker();
  String? _selectedImagePath;
  DateTime _selectedDate = DateTime.now();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> pickImage() async {
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedImage != null) {
        setState(() {
          _selectedImagePath = pickedImage.path;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<void> _saveStudent() async {
    // Validate required fields
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter student name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter student ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<StudentProvider>(context, listen: false);
    
    // Check if student with same ID already exists
    final existingStudent = provider.students.firstWhere(
      (student) => student.id == idController.text.trim(),
      orElse: () => StudentModel(
        name: '',
        id: '',
        phoneNumber: '',
        place: '',
        std: '',
        dob: '',
      ),
    );
    
    if (existingStudent.id.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student with ID ${idController.text} already exists'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final student = StudentModel(
      studentImage: _selectedImagePath,
      name: nameController.text.trim(),
      id: idController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      place: placeController.text.trim(),
      std: selectedDiv ?? 'A',
      dob: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
    );

    try {
      await provider.addStudent(student);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student ${student.name} added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear form
      nameController.clear();
      idController.clear();
      placeController.clear();
      phoneController.clear();
      setState(() {
        selectedDiv = null;
        _selectedImagePath = null;
        _selectedDate = DateTime.now();
      });
      
      // Navigate back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    placeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1323),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          ),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0F1323),
        title: const Center(
          child: Text(
            'Add Student',
            style: TextStyle(
              decorationColor: Colors.white,
              decorationThickness: 2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
          child: Column(
            children: [
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    InkWell(
                      onTap: pickImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: _selectedImagePath != null
                                ? FileImage(File(_selectedImagePath!))
                                : const AssetImage('assets/images/download (12).jpg') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: pickImage,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF0F1323),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text('select image', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.only(right: 340),
                child: Text(
                  'Full Name *',
                  style: TextStyle(
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Students full name',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(183, 14, 95, 18),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 340),
                child: Text(
                  'ID Number *',
                  style: TextStyle(
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: idController,
                decoration: InputDecoration(
                  hintText: 'Enter unique ID number',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(183, 14, 95, 18),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 370),
                child: Text(
                  'Division',
                  style: TextStyle(
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  color: const Color.fromARGB(183, 14, 95, 18),
                ),
                child: DropdownButton<String>(
                  value: selectedDiv,
                  hint: const Text(
                    'Select Division',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  items: div.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDiv = newValue;
                    });
                  },
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 330),
                child: Text(
                  'Date of birth',
                  style: TextStyle(
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(183, 14, 95, 18),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 9),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.green[600]!,
                                onPrimary: Colors.white,
                                surface: const Color.fromARGB(255, 12, 20, 51),
                                onSurface: Colors.white,
                              ),
                              dialogBackgroundColor: const Color.fromARGB(255, 12, 20, 51),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 255),
                child: Text(
                  'Phone number(parent)',
                  style: TextStyle(
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(183, 14, 95, 18),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 395),
                child: Text(
                  'Place',
                  style: TextStyle(
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: placeController,
                decoration: InputDecoration(
                  hintText: 'Enter your city/town',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(183, 14, 95, 18),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _saveStudent,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 12, 20, 51),
                    ),
                    child: const Center(
                      child: Text(
                        'Save Student',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}