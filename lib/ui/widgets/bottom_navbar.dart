import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:detak_medis/views/home/home_page.dart';
import 'package:detak_medis/views/chatbot/chatbot.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
// Tambahkan halaman lain jika perlu

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late PageController pageController;
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomePage(),
    const ChatbotPage(),
    // Tambahkan halaman lain jika perlu
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.white,
        waterDropColor: wMainColor,
        onItemSelected: (index) {
          setState(() => selectedIndex = index);
          pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuad,
          );
        },
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            filledIcon: Icons.house_rounded,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.chat_rounded,
            outlinedIcon: Icons.chat_outlined,
          ),
        ],
      ),
    );
  }
}
