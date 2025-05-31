import 'package:detak_medis/views/doctor/find_doctor.dart';
import 'package:detak_medis/views/profile/profile.dart';
import 'package:detak_medis/views/upload/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Fungsi launch URL dengan tipe Future<void>
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER ===================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome to \nDetak Medics',
                        style: blackTextStyle.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/img/3d_avatar_6.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ================= FEATURE CARDS ===================
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 3,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UploadImagePage(),
                              ),
                            );
                          },
                          child: const FeatureCard(
                            icon: Icons.upload_file,
                            title: 'Upload Your Medical Record',
                          ),
                        ),
                        const SizedBox(width: 12),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FindDoctorPage(),
                              ),
                            );
                          },
                          child: FeatureCard(
                            icon: Icons.search_outlined,
                            title: 'Find Heart Specialist Doctor',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =================== ARTICLES =======================
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 2 / 3,
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Article',
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Scroll hanya untuk daftar artikel
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ArticleCard(
                              title:
                                  '“Is Your Heart in Good Health? 10 Frequent Questions”',
                              subtitle:
                                  'What are the signs of an unhealthy heart? ...',
                              imagePath: 'assets/img/doctor-artikel1.png',
                              url:
                                  'https://www.mountelizabeth.com.sg/id/health-plus/article/10-heart-questions-answered',
                              onTap: _launchURL,
                            ),
                            const SizedBox(height: 16),
                            ArticleCard(
                              title:
                                  '“Living Healthy with Chronic Kidney Disease”',
                              subtitle:
                                  'Chronic kidney disease has been on the rise ...',
                              imagePath: 'assets/img/doctor-artikel2.png',
                              url:
                                  'https://www.mountelizabeth.com.sg/id/health-plus/article/living-with-chronic-kidney-disease',
                              onTap: _launchURL,
                            ),
                            const SizedBox(height: 16),
                            ArticleCard(
                              title:
                                  '“Irregular Heartbeat? It could be Atrial Fibrillation”',
                              subtitle:
                                  'Atrial fibrillation (AF or AFib), is the most commonly ...',
                              imagePath: 'assets/img/doctor-artikel3.png',
                              url:
                                  'https://www.mountelizabeth.com.sg/id/health-plus/article/pulsed-field-ablation-atrial-fibrillation',
                              onTap: _launchURL,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String url;
  final Function(String) onTap;

  const ArticleCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.url,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(url),
      child: Container(
        decoration: BoxDecoration(
          color: wMainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle, style: whiteTextStyle.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 248, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: wMainColor, size: 24),
          const Spacer(),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: wMainColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
