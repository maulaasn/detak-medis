import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:detak_medis/data/doctor_data.dart';
import 'package:detak_medis/ui/widgets/doctor_list.dart';

class FindDoctorPage extends StatefulWidget {
  const FindDoctorPage({super.key});

  @override
  State<FindDoctorPage> createState() => _FindDoctorPageState();
}

class _FindDoctorPageState extends State<FindDoctorPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = allDoctors;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = allDoctors.where((doctor) {
        final name = doctor['name']!.toLowerCase();
        final hospital = doctor['hospital']!.toLowerCase();
        return name.contains(query) || hospital.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wBackgroundColor,
      appBar: AppBar(
        backgroundColor: wMainColor,
        title: const Text('Find Doctor', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Find a doctor or hospital ...',
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Doctor List (reusable widget)
            Expanded(
              child: DoctorList(doctors: filteredDoctors),
            ),
          ],
        ),
      ),
    );
  }
}
