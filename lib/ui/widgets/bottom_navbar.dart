import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:detak_medis/views/home/home_page.dart';
import 'package:detak_medis/views/chatbot/chatbot.dart';

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
  ChatbotPage(
    onSendMessageToModel: (String messageText) async {
      // send the message to the model
      print("Massage sent: $messageText");

    },
  ),
];


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey, 
              width: 0.15,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: wThirdColor,
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.jumpToPage(index);
          },
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: wMainColor),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.message, color: wMainColor),
              icon: Icon(Icons.message_outlined),
              label: 'Chatbot',
            ),
          ],
        ),
      ),

      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: screens,
      ),
    );
  }
}
