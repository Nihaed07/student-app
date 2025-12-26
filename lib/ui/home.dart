import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/bottomnav.dart';
import 'package:flutter_application_1/ui/notification.dart';
import 'package:flutter_application_1/ui/report.dart';
import 'package:flutter_application_1/ui/settings.dart';
import 'package:flutter_application_1/ui/text_form.dart';
import 'package:flutter_application_1/models/models.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _searchController = TextEditingController();

  List<StudentModel> get filteredStudents {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    if (_searchController.text.isEmpty) {
      return provider.students;
    }

    final query = _searchController.text.toLowerCase();
    return provider.searchStudents(query);
  }

  void _deleteStudent(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final student = filteredStudents[index];

        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 12, 20, 51),
          title: const Text(
            'Delete Student',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete ${student.name}?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                final provider = Provider.of<StudentProvider>(
                  context,
                  listen: false,
                );
                await provider.deleteStudent(student.id);

                Navigator.of(context).pop();
                _showSnackBar('${student.name} deleted successfully');
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _editStudent(int index) {
    final student = filteredStudents[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(
          text: student.name,
        );
        TextEditingController idController = TextEditingController(
          text: student.id,
        );
        TextEditingController stdController = TextEditingController(
          text: student.std,
        );

        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 12, 20, 51),
          title: const Text(
            'Edit Student',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[600]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: idController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'ID',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[600]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: stdController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Standard',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[600]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    idController.text.isNotEmpty &&
                    stdController.text.isNotEmpty) {
                  final provider = Provider.of<StudentProvider>(
                    context,
                    listen: false,
                  );
                  final updatedStudent = student.copyWith(
                    name: nameController.text,
                    id: idController.text,
                    std: stdController.text,
                  );

                  await provider.updateStudent(student.id, updatedStudent);

                  Navigator.of(context).pop();
                  _showSnackBar('${student.name} updated successfully');
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.green[600])),
            ),
          ],
        );
      },
    );
  }

  void _toggleAttendance(String studentId, bool value) async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    await provider.toggleAttendance(studentId, DateTime.now(), value);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[600],
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          floatingActionButton: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: FloatingActionButton(
              hoverColor: const Color.fromARGB(183, 38, 59, 175),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextForm()),
                );
              },
              backgroundColor: const Color.fromARGB(255, 12, 20, 51),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          backgroundColor: const Color(0xFF0F1323),
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ),
            ],
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                );
              },
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0F1323),
            title: const Text(
              'Students',
              style: TextStyle(
                fontFamily: 'font1',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 200,
          drawerScrimColor: const Color.fromARGB(154, 15, 19, 35),
          drawer: Drawer(
            shadowColor: Colors.white,
            backgroundColor: const Color(0xFF0F1323),
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 12, 20, 51),
                  ),

                  currentAccountPicture: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  accountName: Text('asannn'),
                  accountEmail: Text('email'),
                ),

                ListTile(
                  leading: const Icon(Icons.home_outlined, color: Colors.white),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNav()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.assignment, color: Colors.white),
                  title: const Text(
                    'Month report',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Report()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  ),
                ),
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    return ListTile(
                      leading: const Icon(Icons.dark_mode, color: Colors.white),
                      title: Row(
                        children: [
                          const Text(
                            'Dark mode',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 70),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Switch(
                              activeThumbColor: Colors.white,
                              inactiveThumbColor: Colors.black,
                              inactiveTrackColor: Colors.white,
                              activeTrackColor: Colors.black,
                              trackOutlineColor: const WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                              value: provider.darkMode,
                              onChanged: (value) {
                                provider.toggleDarkMode(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.green[600]!,
                              onPrimary: Colors.white,
                              surface: const Color.fromARGB(255, 12, 20, 51),
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: const Color.fromARGB(
                              255,
                              12,
                              20,
                              51,
                            ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 12, 20, 51),
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 12, 20, 51),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.green[600],
                    ),
                    hintText: 'Search student by Name or ID',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 12, 20, 51),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey.shade800,
                            backgroundImage:
                                student.studentImage != null &&
                                    student.studentImage!.isNotEmpty
                                ? AssetImage(student.studentImage!)
                                : const AssetImage(
                                    'assets/images/download (12).jpg',
                                  ),
                            child:
                                (student.studentImage == null ||
                                    student.studentImage!.isEmpty)
                                ? Text(
                                    student.name.isNotEmpty
                                        ? student.name[0]
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            student.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            'ID: ${student.id} | Standard: ${student.std}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _editStudent(index),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green[600],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteStudent(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              Switch(
                                activeThumbColor: Colors.white,
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.red,
                                activeTrackColor: Colors.green,
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                                value: student.isPresent,
                                onChanged: (value) {
                                  _toggleAttendance(student.id, value);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
