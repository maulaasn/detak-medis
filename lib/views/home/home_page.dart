import 'package:detak_medis/ui/theme.dart';
import 'package:flutter/material.dart';

import 'package:detak_medis/views/profile/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _launchURL(String url) async {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello,\nAchmad Risel!',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()),
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

              // Chat Assistant Card
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/chatbot');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: wMainColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.smart_toy, color: Colors.white, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Discover Our Healthcare\nChat Assistant',
                          style: whiteTextStyle.copyWith(fontSize: 16),
                        ),
                      ),
                      const Icon(Icons.double_arrow, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Our Features
              Text(
                'Our Features',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      title: 'Scan Report',
                      icon: Icons.qr_code_scanner,
                      onTap: () {
                        // TODO: Aksi scan report
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureCard(
                      title: 'Find Doctor',
                      icon: Icons.search,
                      onTap: () {
                        // TODO: Aksi cari dokter
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Article
              Text(
                'Article',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ArticleCard(
                title: '“Is Your Heart in Good Health? 10 Frequent Questions”',
                subtitle:
                    'What are the signs of an unhealthy heart? What should you do in case of a heart attack? Dr Lim Choon Pin ...',
                imagePath: 'assets/img/doctor-artikel1.png',
                url: 'https://www.mountelizabeth.com.sg/id/health-plus/article/10-heart-questions-answered',
                onTap: _launchURL,
              ),
              const SizedBox(height: 16),
              ArticleCard(
                title: '“Living Healthy with Chronic Kidney Disease”',
                subtitle:
                    'Chronic kidney disease has been on the rise, and it is more important than ever to know what chronic ...',
                imagePath: 'assets/img/doctor-artikel2.png',
                url: 'https://www.mountelizabeth.com.sg/id/health-plus/article/living-with-chronic-kidney-disease',
                onTap: _launchURL,
              ),
              const SizedBox(height: 16),
              ArticleCard(
                title: '“Irregular Heartbeat? It could be Atrial Fibrillation”',
                subtitle:
                    'Atrial fibrillation (AF or AFib), is the most commonly diagnosed arrhythmia in clinical practice ...',
                imagePath: 'assets/img/doctor-artikel3.png',
                url: 'https://www.mountelizabeth.com.sg/id/health-plus/article/pulsed-field-ablation-atrial-fibrillation?sourceType=browse-healthplus&sourceDetail=keyword-search',
                onTap: _launchURL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureCard({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: wBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: wPrimaryColor),
            const SizedBox(height: 12),
            Text(title, style: blackTextStyle),
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
                  Text(title,
                      style: whiteTextStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: whiteTextStyle.copyWith(fontSize: 12)),
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
