import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/bottomnav.dart';
import 'package:flutter_application_1/models/models.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String selectedMonth = DateTime.now().month.toString();
  String selectedYear = DateTime.now().year.toString();
  bool sorting = true;

  final months = const [
    '1', '2', '3', '4', '5', '6', 
    '7', '8', '9', '10', '11', '12'
  ];

  final years = ['2022', '2023', '2024', '2025', '2026', '2027'];

  void _showDownloadSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: const Text(
          'Report downloaded successfully!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final report = provider.getMonthlyReport(selectedMonth, selectedYear);
    
    final displayedStudents = report.entries.toList();
    displayedStudents.sort((a, b) {
      final pa = a.value['percentage'] as int;
      final pb = b.value['percentage'] as int;
      return sorting ? pb.compareTo(pa) : pa.compareTo(pb);
    });

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
        actions: [
          IconButton(
            onPressed: () {
              _showDownloadSnackBar();
            },
            icon: const Icon(Icons.download_sharp, color: Colors.white),
          ),
        ],
        backgroundColor: const Color(0xFF0F1323),
        centerTitle: true,
        title: const Text(
          'Monthly report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Month',
                    value: selectedMonth,
                    items: months,
                    onChanged: (v) => setState(() => selectedMonth = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Year',
                    value: selectedYear,
                    items: years,
                    onChanged: (v) => setState(() => selectedYear = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sort from high to low',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Switch(
                    value: sorting,
                    onChanged: (value) => setState(() => sorting = value),
                    activeThumbColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.red,
                    activeTrackColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: displayedStudents.length,
                itemBuilder: (context, index) {
                  final entry = displayedStudents[index];
                  final student = entry.value['student'] as StudentModel;
                  final present = entry.value['present'] as int;
                  final absent = entry.value['absent'] as int;
                  final total = entry.value['total'] as int;
                  final percentage = entry.value['percentage'] as int;
                  final lowAttendance = percentage < 80;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: lowAttendance
                          ? const Color(0xFF3C2027)
                          : const Color(0xFF0E1622),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: lowAttendance
                            ? const Color(0xFF2D181C)
                            : null,
                        backgroundImage: student.studentImage != null && student.studentImage!.isNotEmpty
                            ? AssetImage(student.studentImage!)
                            : const AssetImage('assets/images/download (12).jpg'),
                        child: (student.studentImage == null || student.studentImage!.isEmpty)
                            ? Text(
                                student.name.isNotEmpty ? student.name[0] : '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),

                      // Title: allow truncation so it never overflows
                      title: Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      // Subtitle: make it flexible and safe from overflow
                      subtitle: Row(
                        children: [
                          // Use Flexible so long text can be truncated
                          Flexible(
                            child: Text(
                              'Present: $present days  ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '| Absent: $absent days',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Trailing: compact vertical layout so it won't push row width
                      trailing: SizedBox(
                        width: 92,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$percentage%',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: lowAttendance
                                    ? const Color(0xFFFA7E7E)
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (lowAttendance)
                              const Icon(
                                Icons.report_problem_rounded,
                                color: Color(0xFFFA7E7E),
                                size: 18,
                              )
                            else
                              const SizedBox(height: 18),
                          ],
                        ),
                      ),

                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF9EA5B1))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1622),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A3340)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            decoration: const InputDecoration(border: InputBorder.none),
            dropdownColor: const Color(0xFF0E1622),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}