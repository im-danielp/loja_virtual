import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [HomeTab()],
    );
  }
}
