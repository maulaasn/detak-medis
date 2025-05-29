import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';

class DoctorList extends StatelessWidget {
  final List<Map<String, String>> doctors;

  const DoctorList({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor['name']!,
                style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
              const SizedBox(height: 4),
              Text(
                'Dokter Jantung',
                style: greyTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                doctor['hospital']!,
                style: blackTextStyle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Jadwal Konsul: ${doctor['schedule']}',
                style: greenTextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}
